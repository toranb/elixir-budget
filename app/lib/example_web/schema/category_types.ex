defmodule ExampleWeb.Schema.CategoryTypes do
  use Absinthe.Schema.Notation

  object :category do
    field(:id, :string)
    field(:name, :string)
  end
end
