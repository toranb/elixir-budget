defmodule Example.Color do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :one, :string
    field :two, :string
    field :three, :string
  end

  @optional_fields [
    :id,
    :one,
    :two,
    :three
  ]

  @doc false
  def changeset(%__MODULE__{} = meta, attrs) do
    meta
    |> cast(attrs, @optional_fields)
  end
end
