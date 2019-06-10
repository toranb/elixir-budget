defmodule Example.Transaction do
  use Ecto.Schema

  schema "transactions" do
    field(:description, :string)
    field(:amount, :integer)
    field(:date, :naive_datetime)
    field(:meta, :map)

    belongs_to(:user, Example.User, foreign_key: :user_id, type: :string)
    belongs_to(:category, Example.Category, foreign_key: :category_id, type: :string)

    timestamps()
  end
end
