defmodule ExampleWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :example

  socket "/socket", ExampleWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :example,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_example_key",
    signing_salt: "SDRzZTsP"

  plug ExampleWeb.Router

  defp port do
    name = Node.self()
    env =
      name
      |> Atom.to_string
      |> String.replace(~r/@.*$/, "")
      |> String.upcase

    String.to_integer(System.get_env("#{env}_PORT") || "4000")
  end

  def init(_key, config) do
    {:ok, Keyword.put(config, :http, [:inet6, port: port()])}
  end

end
