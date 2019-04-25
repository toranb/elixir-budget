defmodule Example.UsersTest do
  use Example.DataCase, async: true

  alias Example.Repo
  alias Example.User

  @id "88EA874FB8A1459439C74D11A78BA0CCB24B4137B9E16B6A7FB63D1FBB42B818"
  @password "abcd1234"
  @username "toran"
  @valid_attrs %{id: @id, username: @username, password: @password}

  test "changeset is invalid if username is too short" do
    attrs = @valid_attrs |> Map.put(:username, "abc")
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    assert Map.get(changeset, :errors) == [
             username:
               {"username must be 4-12 characters", [count: 4, validation: :length, kind: :min]}
           ]
  end

  test "changeset is invalid if username is too long" do
    attrs = @valid_attrs |> Map.put(:username, "abcdefghijklm")
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    assert Map.get(changeset, :errors) == [
             username:
               {"username must be 4-12 characters", [count: 12, validation: :length, kind: :max]}
           ]
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

    assert Map.get(changeset, :errors) == [
             password:
               {"password must be 8-20 characters", [count: 8, validation: :length, kind: :min]}
           ]
  end

  test "changeset is invalid if password is too long" do
    attrs = @valid_attrs |> Map.put(:password, "abcdefghijklmnopqrstu")
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    assert Map.get(changeset, :errors) == [
             password:
               {"password must be 8-20 characters", [count: 20, validation: :length, kind: :max]}
           ]
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
    |> Repo.insert()

    duplicate =
      %User{}
      |> User.changeset(@valid_attrs)

    assert {:error, changeset} = Repo.insert(duplicate)

    assert Map.get(changeset, :errors) == [
             id: {"username already exists", [constraint: :unique, constraint_name: "users_pkey"]}
           ]
  end
end
