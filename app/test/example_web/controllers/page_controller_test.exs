defmodule ExampleWeb.PageControllerTest do
  use ExampleWeb.ConnCase

  import Plug.Conn, only: [get_session: 2]

  @name "toran"
  @password "abcd1234"
  @id "88EA874FB8A1459439C74D11A78BA0CCB24B4137B9E16B6A7FB63D1FBB42B818"
  @login %{username: @name, password: @password}

  test "successful login will put user id into session and redirect", %{conn: conn} do
    result = post(conn, Routes.registration_path(conn, :create, @login))
    assert html_response(result, 302) =~ "redirected"
    session_id = get_session(result, :user_id)
    assert session_id == nil

    login = post(conn, Routes.login_path(conn, :create, @login))
    assert html_response(login, 302) =~ "redirected"
    assert get_flash(login, :error) == nil
    for {"location", value} <- login.resp_headers, do: assert(value == "/budget")

    session_id = get_session(login, :user_id)
    assert session_id == @id
  end

  test "failed login will not put user id into session", %{conn: conn} do
    credentials = %{username: "brandon", password: @password}
    login = post(conn, Routes.login_path(conn, :create, credentials))
    assert get_flash(login, :error) == "incorrect username or password"
    session_id = get_session(login, :user_id)
    assert session_id == nil
  end
end
