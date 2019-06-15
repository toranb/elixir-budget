defmodule Example.Number do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :value, :string
  end

  @optional_fields [
    :id,
    :value
  ]

  @doc false
  def changeset(%__MODULE__{} = meta, attrs) do
    meta
    |> cast(attrs, @optional_fields)
  end
end
