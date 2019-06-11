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

  def update(%{id: id, transaction: transaction}) do
    Transaction
    |> Repo.get(id)
    |> Repo.preload(:category)
    |> Transaction.changeset(transaction)
    |> Repo.update()
  end
end
