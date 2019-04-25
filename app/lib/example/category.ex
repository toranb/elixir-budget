defmodule Example.Category do
  use Ecto.Schema

  @primary_key {:id, :string, []}
  schema "categories" do
    field(:name, :string)

    has_many(:transactions, Example.Transaction, foreign_key: :category_id)

    timestamps()
  end
end
