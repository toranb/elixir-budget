defmodule Example.Transactions do
  import Ecto.Query, warn: false

  alias Example.Repo
  alias Example.Transaction

  def all(user_id) do
    Repo.all(from(t in Transaction, where: t.user_id == ^user_id))
  end

  def insert(attrs \\ %{}) do
    Transaction
    |> struct(attrs)
    |> Repo.preload(:category)
    |> Repo.insert()
  end
end
