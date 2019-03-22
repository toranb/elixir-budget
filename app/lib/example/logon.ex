defmodule Example.Logon do
  use GenServer

  alias Example.Hash
  alias Example.User
  alias Example.Users
  alias Example.Password

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: via(:logon))
  end

  defp via(name), do: Example.Registry.via(name)

  @impl GenServer
  def init(:ok) do
    {:ok, %{}}
  end

  def put(name, username, password) do
    GenServer.call(via(name), {:put, username, password})
  end

  @impl GenServer
  def handle_call({:put, username, password}, _timeout, state) do
    hash = Password.hash(password)
    id = Hash.hmac(:user, username)
    changeset = User.changeset(%User{}, %{id: id, username: username, password: password, hash: hash})
    case Users.insert(changeset) do
      {:ok, _result} ->
        {:reply, {:ok, {id, username}}, state}
      {:error, changeset} ->
        {_key, {message, _}} = Enum.find(changeset.errors, fn(i) -> i end)
        {:reply, {:error, {id, message}}, state}
    end
  end
end
