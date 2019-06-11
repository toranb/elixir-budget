defmodule Example.Item do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :type, :string
    field :colors, {:array, :string}
  end

  @optional_fields [
    :type,
    :colors
  ]

  @doc false
  def changeset(%__MODULE__{} = meta, attrs) do
    meta
    |> cast(attrs, @optional_fields)
  end
end
