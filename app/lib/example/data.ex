defmodule Example.Data do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field(:email, :string)
    field(:number, :integer)
  end

  @optional_fields [
    :email,
    :number
  ]

  @doc false
  def changeset(%__MODULE__{} = meta, attrs) do
    meta
    |> cast(attrs, @optional_fields)
  end
end
