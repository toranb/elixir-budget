defmodule ExampleWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom
  import_types ExampleWeb.Schema.CategoryTypes
  import_types ExampleWeb.Schema.TransactionTypes

  alias ExampleWeb.Resolvers

  query do

    @desc "Get transactions"
    field :transactions, list_of(:transaction) do
      resolve &Resolvers.Transaction.all_transactions/3
    end

  end

  mutation do

    @desc "Add transaction"
    field :create_transaction, type: :transaction do
      arg :description, non_null(:string)
      arg :amount, non_null(:integer)
      arg :date, non_null(:naive_datetime)
      arg :category_id, non_null(:string)

      resolve &Resolvers.Transaction.create_transaction/3
    end

  end

end
