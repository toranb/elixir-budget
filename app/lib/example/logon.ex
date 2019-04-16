defmodule Example.Logon do
  use GenServer

  alias Example.Hash
  alias Example.User
  alias Example.Users
  alias Example.UserCache
  alias Example.Password

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl GenServer
  def init(:ok) do
    :net_kernel.monitor_nodes(true)

    :pg2.join(:example, self())
    Users.all() |> UserCache.insert
    {:ok, nil, {:continue, :init}}
  end

  @impl GenServer
  def handle_continue(:init, state) do
    {:noreply, state}
  end

  def get(_name, id) do
    UserCache.find_with_id(id)
  end

  def get_by_username_and_password(_name, username, password) do
    UserCache.find_with_username_and_password(username, password)
  end

  def put(_name, username, password) do
    GenServer.call(__MODULE__, {:put, username, password})
  end

  @impl GenServer
  def handle_call({:put, username, password}, _timeout, state) do
    hash = Password.hash(password)
    id = Hash.hmac(:user, username)
    changeset = User.changeset(%User{}, %{id: id, username: username, password: password, hash: hash})
    case Users.insert(changeset) do
      {:ok, _result} ->
        members = :pg2.get_members(:example)
        Enum.map(members, fn (pid) ->
          GenServer.cast(pid, {:merge, id, username, hash})
        end)

        {:reply, {:ok, {id, username}}, state}
      {:error, changeset} ->
        {_key, {message, _}} = Enum.find(changeset.errors, fn(i) -> i end)
        {:reply, {:error, {id, message}}, state}
    end
  end

  @impl GenServer
  def handle_cast({:merge, id, username, hash}, state) do
    UserCache.insert(id, username, hash)
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:nodeup, node}, state) do
    for {id, {username, hash}} <- UserCache.all() do
      GenServer.cast({__MODULE__, node}, {:merge, id, username, hash})
    end
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
