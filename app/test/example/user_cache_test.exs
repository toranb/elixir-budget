defmodule Example.UserCacheTest do
  use Example.DataCase, async: true

  require Logger

  alias Example.Repo
  alias Example.User
  alias Example.Users
  alias Example.UserCache
  alias Example.Password

  @id "88EA874FB8A1459439C74D11A78BA0CCB24B4137B9E16B6A7FB63D1FBB42B818"
  @password "abcd1234"
  @username "toran"
  @valid_attrs %{id: @id, username: @username, password: @password}

  test "insert all adds each user to ets" do
    create_ets_table()

    hash_one = "987654321"
    attrs = @valid_attrs |> Map.put(:hash, hash_one)

    hash_two = "54545454"
    password_two = "defg4567"
    two = "875C807AE0F492AAF5897D7693A628AE5E54801CD73C651EC98088898FA56E0C"
    jarrod_attrs = %{id: two, username: "jarrod", password: password_two, hash: hash_two}

    %User{}
    |> User.changeset(jarrod_attrs)
    |> Repo.insert()

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()

    Users.all() |> UserCache.insert()

    results = :ets.match(:users_table, {:"$1", :"$2"})

    users =
      Enum.reduce(results, %{}, fn [id, {username, hash}], acc ->
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
    |> Repo.insert()

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()

    assert UserCache.find_with_username_and_password(@username, @password) === nil

    Users.all() |> UserCache.insert()

    assert UserCache.find_with_username_and_password(@username, @password) === @id
    assert UserCache.find_with_username_and_password(@username, "abc12") === nil
    assert UserCache.find_with_username_and_password("jarrod", password_two) === two
    assert UserCache.find_with_username_and_password("jarrod", "") === nil
    assert UserCache.find_with_username_and_password(@username, password_two) === nil
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
    |> Repo.insert()

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()

    assert UserCache.find_with_id(@id) === nil

    Users.all() |> UserCache.insert()

    assert UserCache.find_with_id(@id) === @username
    assert UserCache.find_with_id(two) === username_two
    assert UserCache.find_with_id("x") === nil
    assert UserCache.find_with_id("") === nil
    assert UserCache.find_with_id(nil) === nil
  end

  defp create_ets_table do
    delete_ets_table()
    UserCache.create()
  rescue
    _ ->
      Logger.debug("create_ets_table failed")
  end

  defp delete_ets_table do
    :ets.delete_all_objects(:users_table)
  rescue
    _ ->
      Logger.debug("delete_ets_table failed")
  end
end
