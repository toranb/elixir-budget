defmodule Example.User do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :string, []}
  schema "users" do
    field(:username, :string)
    field(:hash, :string)
    field(:password, :string, virtual: true)

    has_many(:transactions, Example.Transaction, foreign_key: :user_id)

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:id, :username, :password, :hash])
    |> validate_required([:username, :password])
    |> unique_constraint(:id, name: :users_pkey, message: "username already exists")
    |> validate_length(:username, min: 4, max: 12, message: "username must be 4-12 characters")
    |> validate_length(:password, min: 8, max: 20, message: "password must be 8-20 characters")
  end
end
