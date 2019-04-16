defmodule Example.Category do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :string, []}
  schema "categories" do
    field :name, :string

    has_many :transactions, Example.Transaction, foreign_key: :category_id

    timestamps()
  end

  def changeset(category, params \\ %{}) do
    category
      |> cast(params, [:id, :name])
      |> unique_constraint(:id, name: :categories_pkey, message: "category already exists")
  end

end
