defmodule Example.Transaction do
  use Ecto.Schema

  import Ecto.Changeset

  schema "transactions" do
    field(:description, :string)
    field(:amount, :integer)
    field(:date, :naive_datetime)
    field(:meta, :map)

    belongs_to(:user, Example.User, foreign_key: :user_id, type: :string)
    belongs_to(:category, Example.Category, foreign_key: :category_id, type: :string)

    timestamps()
  end

  def changeset(transaction, params \\ %{}) do
    transaction
      |> cast(params, [:description, :amount, :meta])
  end
end
