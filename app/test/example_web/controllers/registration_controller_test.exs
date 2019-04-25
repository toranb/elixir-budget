defmodule ExampleWeb.RegistrationControllerTest do
  use ExampleWeb.ConnCase

  alias Example.User
  alias Example.Users

  @name "toran"
  @password "abcd1234"
  @id "88EA874FB8A1459439C74D11A78BA0CCB24B4137B9E16B6A7FB63D1FBB42B818"
  @login %{username: @name, password: @password}

  test "successful registration will put user into the database and redirect", %{conn: conn} do
    result = post(conn, Routes.registration_path(conn, :create, @login))
    assert html_response(result, 302) =~ "redirected"
    assert get_flash(result, :error) == nil
    assert get_flash(result, :info) == "Account Created!"
    for {"location", value} <- result.resp_headers, do: assert(value == "/")

    users = Users.all()
    assert Enum.count(users) == 1

    %User{id: id, username: username, hash: hash} = Users.get!(@id)
    assert id == @id
    assert username == @name
    assert hash != @password
  end

  test "failed registration will not put user into the database", %{conn: conn} do
    invalid = %{username: "joe", password: @password}
    result = post(conn, Routes.registration_path(conn, :create, invalid))
    assert get_flash(result, :error) == "username must be 4-12 characters"
    assert get_flash(result, :info) == nil
    for {"location", value} <- result.resp_headers, do: assert(value == "/signup")

    users = Users.all()
    assert Enum.empty?(users)
  end
end
