defmodule Example.Transaction do
  use Ecto.Schema

  import Ecto.Changeset

  schema "transactions" do
    field(:description, :string)
    field(:amount, :integer)
    field(:date, :naive_datetime)

    embeds_one :meta, Example.Meta, on_replace: :update

    belongs_to(:user, Example.User, foreign_key: :user_id, type: :string)
    belongs_to(:category, Example.Category, foreign_key: :category_id, type: :string)

    timestamps()
  end

  def changeset(transaction, params \\ %{}) do
    transaction
      |> cast(params, [:description, :amount])
      |> cast_embed(:meta, with: &Example.Meta.changeset/2)
  end
end
