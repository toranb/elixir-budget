defmodule ExampleWeb.Schema.TransactionTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  scalar :map do
    parse fn input ->
      case Poison.decode(input.value) do
        {:ok, result} -> result
        _ -> :error
      end
    end

    serialize &Poison.encode!/1
  end

  object :transaction do
    field(:id, :id)
    field(:description, :string)
    field(:amount, :integer)
    field(:date, :naive_datetime)
    field(:category_id, :string)
    field(:meta, :map)

    field :category, :category, resolve: dataloader(Transaction)
  end

end
