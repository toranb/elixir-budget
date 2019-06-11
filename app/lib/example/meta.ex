defmodule Example.Meta do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field(:name, :string)
    embeds_one(:data, Example.Data, on_replace: :update)
  end

  @optional_fields [
    :name,
    :data
  ]

  @doc false
  def changeset(%__MODULE__{} = meta, attrs) do
    meta
    |> cast(attrs, [:name])
    |> cast_embed(:data, with: &Example.Data.changeset/2)
  end
end
