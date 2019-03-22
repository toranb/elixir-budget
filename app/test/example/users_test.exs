defmodule Example.UsersTest do
  use Example.DataCase, async: true

  require Logger

  alias Example.Repo
  alias Example.User
  alias Example.Users
  alias Example.Password

  @id "88EA874FB8A1459439C74D11A78BA0CCB24B4137B9E16B6A7FB63D1FBB42B818"
  @password "abcd1234"
  @username "toran"
  @valid_attrs %{id: @id, username: @username, password: @password}

  test "changeset is invalid if username is too short" do
    attrs = @valid_attrs |> Map.put(:username, "abc")
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?
    assert Map.get(changeset, :errors) == [username: {"username must be 4-12 characters", [count: 4, validation: :length, kind: :min]}]
  end

  test "changeset is invalid if username is too long" do
    attrs = @valid_attrs |> Map.put(:username, "abcdefghijklm")
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?
    assert Map.get(changeset, :errors) == [username: {"username must be 4-12 characters", [count: 12, validation: :length, kind: :max]}]
  end

  test "changeset is fine with 4 char username" do
    attrs = @valid_attrs |> Map.put(:username, "abcd")
    changeset = User.changeset(%User{}, attrs)
    assert changeset.valid?
    assert Map.get(changeset, :errors) == []
  end

  test "changeset is fine with 12 char username" do
    attrs = @valid_attrs |> Map.put(:username, "abcdefghijkl")
    changeset = User.changeset(%User{}, attrs)
    assert changeset.valid?
    assert Map.get(changeset, :errors) == []
  end

  test "changeset is invalid if password is too short" do
    attrs = @valid_attrs |> Map.put(:password, "abcdefg")
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?
    assert Map.get(changeset, :errors) == [password: {"password must be 8-20 characters", [count: 8, validation: :length, kind: :min]}]
  end

  test "changeset is invalid if password is too long" do
    attrs = @valid_attrs |> Map.put(:password, "abcdefghijklmnopqrstu")
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?
    assert Map.get(changeset, :errors) == [password: {"password must be 8-20 characters", [count: 20, validation: :length, kind: :max]}]
  end

  test "changeset is fine with 20 char password" do
    attrs = @valid_attrs |> Map.put(:password, "abcdefghijklmnopqrst")
    changeset = User.changeset(%User{}, attrs)
    assert changeset.valid?
    assert Map.get(changeset, :errors) == []
  end

  test "changeset is fine with 8 char password" do
    attrs = @valid_attrs |> Map.put(:password, "abcdefgh")
    changeset = User.changeset(%User{}, attrs)
    assert changeset.valid?
    assert Map.get(changeset, :errors) == []
  end

  test "changeset is invalid if username is used already" do
    %User{}
      |> User.changeset(@valid_attrs)
      |> Repo.insert

    duplicate =
      %User{}
      |> User.changeset(@valid_attrs)
    assert {:error, changeset} = Repo.insert(duplicate)
    assert Map.get(changeset, :errors) == [id: {"username already exists", [constraint: :unique, constraint_name: "users_pkey"]}]
  end

  test "transform inserts id, username and hash values into ets for each user" do
    create_ets_table()

    hash_one = "987654321"
    attrs = @valid_attrs |> Map.put(:hash, hash_one)

    hash_two = "54545454"
    password_two = "defg4567"
    two = "875C807AE0F492AAF5897D7693A628AE5E54801CD73C651EC98088898FA56E0C"
    jarrod_attrs = %{id: two, username: "jarrod", password: password_two, hash: hash_two}

    %User{}
      |> User.changeset(jarrod_attrs)
      |> Repo.insert

    %User{}
      |> User.changeset(attrs)
      |> Repo.insert

    Users.all() |> User.transform

    results = :ets.match(:users_table, {:"$1", :"$2"})
    users = Enum.reduce(results, %{}, fn([id, {username, hash}], acc) ->
      Map.put(acc, id, {username, hash})
    end)

    assert Map.keys(users) == [two, @id]
    assert Map.get(users, two) == {"jarrod", hash_two}
    assert Map.get(users, @id) == {@username, hash_one}
  end

  test "find with username and password" do
    create_ets_table()

    hash_one = Password.hash(@password)
    attrs = @valid_attrs |> Map.put(:hash, hash_one)

    password_two = "defg4567"
    hash_two = Password.hash(password_two)
    two = "875C807AE0F492AAF5897D7693A628AE5E54801CD73C651EC98088898FA56E0C"
    jarrod_attrs = %{id: two, username: "jarrod", password: password_two, hash: hash_two}

    %User{}
      |> User.changeset(jarrod_attrs)
      |> Repo.insert

    %User{}
      |> User.changeset(attrs)
      |> Repo.insert

    assert User.find_with_username_and_password(@username, @password) === nil

    Users.all() |> User.transform

    assert User.find_with_username_and_password(@username, @password) === @id
    assert User.find_with_username_and_password(@username, "abc12") === nil
    assert User.find_with_username_and_password("jarrod", password_two) === two
    assert User.find_with_username_and_password("jarrod", "") === nil
    assert User.find_with_username_and_password(@username, password_two) === nil
  end

  test "find with id" do
    create_ets_table()

    hash_one = Password.hash(@password)
    attrs = @valid_attrs |> Map.put(:hash, hash_one)

    username_two = "jarrod"
    password_two = "defg4567"
    hash_two = Password.hash(password_two)
    two = "875C807AE0F492AAF5897D7693A628AE5E54801CD73C651EC98088898FA56E0C"
    jarrod_attrs = %{id: two, username: username_two, password: password_two, hash: hash_two}

    %User{}
      |> User.changeset(jarrod_attrs)
      |> Repo.insert

    %User{}
      |> User.changeset(attrs)
      |> Repo.insert

    assert User.find_with_id(@id) === nil

    Users.all() |> User.transform

    assert User.find_with_id(@id) === @username
    assert User.find_with_id(two) === username_two
    assert User.find_with_id("x") === nil
    assert User.find_with_id("") === nil
    assert User.find_with_id(nil) === nil
  end

  defp create_ets_table do
    delete_ets_table()

    :ets.new(:users_table, [:named_table, :set, :public, read_concurrency: true])

    rescue
      _ ->
        Logger.debug "create_ets_table failed"
  end

  defp delete_ets_table do
    :ets.delete_all_objects(:users_table)

    rescue
      _ ->
        Logger.debug "delete_ets_table failed"
  end

end
