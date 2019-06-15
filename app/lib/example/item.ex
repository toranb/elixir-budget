defmodule Example.Item do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :type, :string
    embeds_many(:colors, Example.Color, on_replace: :delete)
  end

  @optional_fields [
    :id,
    :type
  ]

  @doc false
  def changeset(%__MODULE__{} = meta, attrs) do
    meta
    |> cast(attrs, @optional_fields)
    |> cast_embed(:colors, with: &Example.Color.changeset/2)
  end
end
