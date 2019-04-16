defmodule Example.ClusterSync do
  use GenServer

  @one_second :timer.seconds(1)
  @two_seconds :timer.seconds(2)
  @ten_seconds :timer.seconds(10)

  alias Example.Clusters

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: via(:sync))
  end

  defp via(name), do: Example.Registry.via(name)

  @impl GenServer
  def init(:ok) do
    Process.send_after(self(), :write, @one_second)
    Process.send_after(self(), :query, @two_seconds)

    id = Atom.to_string(Node.self)
    {:ok, %{id: id}}
  end

  @impl GenServer
  def handle_info(:write, state) do
    Clusters.upsert_by(state)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:query, state) do
    %{:id => node} = state

    Clusters.all()
      |> Enum.map(&Map.from_struct(&1))
      |> Enum.filter(fn (%{:id => id}) -> id != node end)
      |> Enum.map(fn (%{:id => id}) -> String.to_atom(id) end)
      |> Enum.map(&({&1, Node.ping(&1) == :pong}))

    Process.send_after(self(), :query, @ten_seconds)

    {:noreply, state}
  end

end
