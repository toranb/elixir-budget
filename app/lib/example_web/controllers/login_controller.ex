defmodule ExampleWeb.LoginController do
  use ExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"username" => username, "password" => password}) do
    case Example.Logon.get_by_username_and_password(:logon, username, password) do
      nil ->
        conn
        |> put_flash(:error, "incorrect username or password")
        |> render("index.html")

      id ->
        path = Routes.budget_path(conn, :index)

        conn
        |> put_session(:user_id, id)
        |> redirect(to: path)
    end
  end
end
