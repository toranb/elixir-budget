defmodule Example.Meta do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field(:name, :string)
    embeds_one(:data, Example.Data, on_replace: :update)
    embeds_many(:items, Example.Item, on_replace: :delete)
  end

  @doc false
  def changeset(%__MODULE__{} = meta, attrs) do
    meta
    |> cast(attrs, [:id, :name])
    |> cast_embed(:data, with: &Example.Data.changeset/2)
    |> cast_embed(:items, with: &Example.Item.changeset/2)
  end
end
