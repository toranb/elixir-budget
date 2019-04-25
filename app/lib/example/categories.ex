defmodule Example.Categories do
  import Ecto.Query, warn: false

  alias Example.Repo
  alias Example.Category
  alias Example.Transaction

  def all do
    Repo.all(Category)
  end

  def category_for_transaction(%Transaction{} = transaction) do
    Category
    |> Repo.get(transaction.category_id)
  end

  def insert!(attrs \\ %{}) do
    Category
    |> struct(attrs)
    |> Repo.insert!()
  end
end
