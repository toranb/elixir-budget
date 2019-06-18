defmodule Example.EmbedsMany do
  import Ecto.Changeset

  def cast_embed_many(%Ecto.Changeset{} = changeset, field) do
    updated_changeset =
      changeset
      |> cast_embed(field)

    altered_changeset =
      updated_changeset
      |> get_change(field)
      |> Enum.map(&alter_action/1)

    all_changes = Map.put(updated_changeset.changes, field, altered_changeset)

    %Ecto.Changeset{updated_changeset | changes: all_changes}
  end

  def alter_action(%Ecto.Changeset{action: :replace} = changeset) do
    %Ecto.Changeset{changeset | action: :update}
  end

  def alter_action(%Ecto.Changeset{action: _} = changeset), do: changeset
end
