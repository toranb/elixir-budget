defmodule Example.Meta do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :data, :map
  end

  @optional_fields [
    :name,
    :data
  ]

  @doc false
  def changeset(%__MODULE__{} = meta, attrs) do
    meta
    |> cast(attrs, @optional_fields)
  end
end
