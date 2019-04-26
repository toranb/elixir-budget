defmodule Example.ClusterSync do
  use GenServer

  @one_second :timer.seconds(1)
  @two_seconds :timer.seconds(2)
  @ten_seconds :timer.seconds(10)

  alias Example.Storage

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
    %{id: id} = state
    Storage.set(id, id)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:query, state) do
    %{id: id} = state

    members()
      |> Enum.filter(fn (node) -> node != id end)
      |> Enum.map(&String.to_atom/1)
      |> Enum.map(&({&1, Node.ping(&1) == :pong}))

    Process.send_after(self(), :query, @ten_seconds)

    {:noreply, state}
  end

  def members do
    case Storage.command(["SCAN", 0, "MATCH", "[^_]*", "COUNT", 999]) do
      {:error, _ } ->
        []
      {:ok, [_given_index, node]} ->
        node
    end
  end

end
