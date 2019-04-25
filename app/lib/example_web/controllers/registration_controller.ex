defmodule ExampleWeb.RegistrationController do
  use ExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"username" => username, "password" => password}) do
    case Example.Logon.put(:logon, username, password) do
      {:ok, {_id, _username}} ->
        path = Routes.login_path(conn, :index)

        conn
        |> put_flash(:info, "Account Created!")
        |> redirect(to: path)

      {:error, {_id, message}} ->
        path = Routes.registration_path(conn, :index)

        conn
        |> put_flash(:error, message)
        |> redirect(to: path)
    end
  end
end
