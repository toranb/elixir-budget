defmodule Example.UserCache do
  @table :users_table

  def create do
    :ets.new(@table, [:named_table, :set, :public, read_concurrency: true])
  end

  def insert(id, username, hash) do
    :ets.insert(@table, {id, {username, hash}})
  end

  def insert(users) do
    Enum.each(users, fn %Example.User{id: id, username: username, hash: hash} ->
      insert(id, username, hash)
    end)
  end

  def find_with_id(id) do
    case :ets.lookup(@table, id) do
      [{_, {username, _}}] ->
        username

      [] ->
        nil
    end
  end

  def find_with_username_and_password(username, password) do
    users = :ets.match(@table, {:"$1", :"$2"})

    case Enum.filter(users, fn [_, {k, _}] -> k == username end) do
      [[id, {_username, hash}]] ->
        if Example.Password.verify(password, hash) do
          id
        end

      [] ->
        Example.Password.dummy_verify()
        nil
    end
  end
end
