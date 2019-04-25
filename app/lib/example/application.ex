defmodule Example.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # List all child processes to be supervised
    children = [
      Example.Repo,
      ExampleWeb.Endpoint,
      {Registry, keys: :unique, name: Example.Registry},
      %{id: :users_cache, start: {Cachex, :start_link, [:users_cache, []]}},
      %{id: :categories_cache, start: {Cachex, :start_link, [:categories_cache, []]}},
      Example.Logon,
      Example.Collection,
      Example.ClusterSync
    ]

    :pg2.create(:example)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Example.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
