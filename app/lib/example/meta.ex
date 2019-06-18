defmodule Example.Meta do
  use Ecto.Schema

  import Ecto.Changeset
  import Example.EmbedsMany, only: [cast_embed_many: 2]

  embedded_schema do
    field(:name, :string)
    embeds_one(:data, Example.Data, on_replace: :update)
    embeds_many(:items, Example.Item, on_replace: :delete)
    embeds_many(:numbers, Example.Number, on_replace: :delete)
  end

  @doc false
  def changeset(%__MODULE__{} = meta, attrs) do
    meta
    |> cast(attrs, [:id, :name])
    |> cast_embed(:data, with: &Example.Data.changeset/2)
    |> cast_embed(:items, with: &Example.Item.changeset/2)
    |> cast_embed_many(:numbers)
  end
end
