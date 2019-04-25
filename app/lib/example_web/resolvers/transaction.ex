defmodule ExampleWeb.Resolvers.Transaction do
  alias Example.Transactions

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
end
