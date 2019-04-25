defmodule ExampleWeb.Authenticate do
  import Phoenix.Controller, only: [redirect: 2]
  import Plug.Conn, only: [get_session: 2, assign: 3, put_session: 3, halt: 1, put_private: 3]

  alias ExampleWeb.Router.Helpers, as: Routes

  def authentication(conn, _opts) do
    case get_session(conn, :user_id) do
      nil ->
        conn

      id ->
        username = Example.Logon.get(:logon, "#{id}")

        conn
        |> put_private(:absinthe, %{context: %{current_user: id}})
        |> assign(:current_user, %{id: id, username: username})
    end
  end

  def redirect_unauthorized(conn, _opts) do
    current_user = Map.get(conn.assigns, :current_user)

    if current_user != nil and current_user.username != nil do
      conn
    else
      conn
      |> put_session(:return_to, conn.request_path)
      |> redirect(to: Routes.login_path(conn, :index))
      |> halt()
    end
  end
end
