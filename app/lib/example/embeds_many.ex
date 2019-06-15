defmodule Example.EmbedsMany do
  alias Example.EmbedMany

  def cast_embed_update(%Ecto.Changeset{} = changeset, field, attrs, struct) do
    %EmbedMany{updated: updated} =
      changeset
      |> EmbedMany.new(field, attrs, struct)
      |> EmbedMany.merge()
      |> EmbedMany.append()
      |> EmbedMany.apply_changeset()

    changeset
    |> Ecto.Changeset.put_change(field, updated)
  end
end
