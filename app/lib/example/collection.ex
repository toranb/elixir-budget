defmodule Example.Collection do
  use GenServer

  alias Example.Categories
  alias Example.CategoryCache

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: via(:collection))
  end

  defp via(name), do: Example.Registry.via(name)

  @impl GenServer
  def init(:ok) do
    Categories.all() |> CategoryCache.insert()
    {:ok, nil, {:continue, :init}}
  end

  @impl GenServer
  def handle_continue(:init, state) do
    {:noreply, state}
  end

  def all(_name) do
    CategoryCache.all()
  end
end
