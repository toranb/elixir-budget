defmodule Example.UserCache do

  @table :users_cache

  def all do
    query = Cachex.Query.create(true, { :key, :value })
    Cachex.stream!(@table, query) |> Enum.to_list
  end

  def insert(id, username, hash) do
    Cachex.put(@table, id, {username, hash})
  end

  def insert(users) do
    Enum.each(users, fn(%Example.User{id: id, username: username, hash: hash}) ->
      insert(id, username, hash)
    end)
  end

  def find_with_id(id) do
    case Cachex.get(@table, id) do
      {:ok, {username, _}} -> username
      {:ok, nil} -> nil
    end
  end

  def find_with_username_and_password(username, password) do
    users = all()
    case Enum.filter(users, fn {_, {k, _}} -> k == username end) do
      [{id, {_username, hash}}] ->
        if Example.Password.verify(password, hash) do
          id
        end
      [] ->
        Example.Password.dummy_verify()
        nil
    end
  end

end
