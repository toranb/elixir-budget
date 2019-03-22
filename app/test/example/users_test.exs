defmodule Example.UsersTest do
  use Example.DataCase, async: true

  alias Example.Repo
  alias Example.User
  alias Example.Users
  alias Example.Password

  @id "88EA874FB8A1459439C74D11A78BA0CCB24B4137B9E16B6A7FB63D1FBB42B818"
  @valid_attrs %{id: @id, username: "toran", password: "abcd1234"}

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

  test "transform returns map with id, username and hash values" do
    two = "875C807AE0F492AAF5897D7693A628AE5E54801CD73C651EC98088898FA56E0C"
    jarrod_attrs = %{id: two, username: "jarrod", password: "abcd1234"}

    %User{}
      |> User.changeset(jarrod_attrs)
      |> Repo.insert

    %User{}
      |> User.changeset(@valid_attrs)
      |> Repo.insert

    result = Users.all() |> User.transform

    assert Map.keys(result) == [two, @id]
    assert Map.get(result, two) == {"jarrod", nil}
    assert Map.get(result, @id) == {"toran", nil}
  end


  test "find with username and password" do
    state = %{}
    username = "toran"
    password = "abc123"
    password_hash = Password.hash(password)

    assert User.find_with_username_and_password(state, username, password) === nil

    new_state = Map.put(state, @id, {username, password_hash})
    assert User.find_with_username_and_password(new_state, username, password) === @id
    assert User.find_with_username_and_password(new_state, username, "abc12") === nil

    username_two = "jarrod"
    password_two = "def456"
    password_hash_two = Password.hash(password_two)
    id_two = "962EDC73E485BC59B2DD66A6728576F741575FC69FFE88581826C01BBBACC3E9"
    last_state = Map.put(new_state, id_two, {username_two, password_hash_two})
    assert User.find_with_username_and_password(last_state, username, password) === @id
    assert User.find_with_username_and_password(last_state, username_two, password_two) === id_two
    assert User.find_with_username_and_password(last_state, username_two, "") === nil
    assert User.find_with_username_and_password(last_state, username, password_two) === nil
  end

end
