defmodule ExampleWeb.AuthenticatorTest do
  use ExampleWeb.ConnCase, async: false

  test "login will authenticate the user and redirect unauthenticated requests", %{conn: conn} do
    request = get(conn, Routes.budget_path(conn, :index))
    assert redirected_to(request, 302) =~ "/"
    assert Map.get(request.assigns, :current_user) == nil

    name = "toran"
    password = "abcd1234"
    login = %{username: name, password: password}

    created = post(request, Routes.registration_path(conn, :create, login))
    assert html_response(created, 302) =~ "redirected"
    assert Map.get(created.assigns, :current_user) == nil

    denied = get(created, Routes.budget_path(conn, :index))
    assert redirected_to(denied, 302) =~ "/"
    assert Map.get(denied.assigns, :current_user) == nil

    authenticated = post(denied, Routes.login_path(conn, :create, login))
    assert html_response(authenticated, 302) =~ "redirected"
    assert Map.get(authenticated.assigns, :current_user) == nil

    authorized = get(authenticated, Routes.budget_path(conn, :index))
    assert String.match?(html_response(authorized, 200), ~r/.*main.js.*/)
    assert Map.get(authorized.assigns, :current_user) != nil
    %{id: id, username: username} = Map.get(authorized.assigns, :current_user)
    assert id == "88EA874FB8A1459439C74D11A78BA0CCB24B4137B9E16B6A7FB63D1FBB42B818"
    assert username == name

    logout = get(authorized, Routes.logout_path(conn, :index))
    assert html_response(logout, 302) =~ "redirected"
    assert Map.get(logout.assigns, :current_user) == nil

    denied_again = get(logout, Routes.budget_path(conn, :index))
    assert redirected_to(denied_again, 302) =~ "/"
    assert Map.get(denied_again.assigns, :current_user) == nil
  end
end
