defmodule ExampleWeb.Schema.TransactionTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :transaction do
    field(:id, :id)
    field(:description, :string)
    field(:amount, :integer)
    field(:date, :naive_datetime)
    field(:category_id, :string)

    field :category, :category, resolve: dataloader(Transaction)
  end

end
