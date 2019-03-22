defmodule ExampleWeb.Schema.TransactionTypes do
  use Absinthe.Schema.Notation

  object :transaction do
    field :id, :id
    field :description, :string
    field :amount, :integer
    field :date, :naive_datetime
  end
end
