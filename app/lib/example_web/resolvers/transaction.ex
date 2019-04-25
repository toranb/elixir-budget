defmodule ExampleWeb.Resolvers.Transaction do
  alias Example.Transactions
  alias Example.Categories

  def all_transactions(_parent, _args, %{context: %{current_user: id}}) do
    {:ok, Transactions.all(id)}
  end

  def all_transactions(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def create_transaction(_parent, args, %{context: %{current_user: id}}) do
    args |> Map.put(:user_id, id) |> Transactions.insert()
  end

  def create_transaction(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def category_for_transaction(transaction, _args, %{context: %{current_user: _id}}) do
    {:ok, Categories.category_for_transaction(transaction)}
  end

  def category_for_transaction(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
