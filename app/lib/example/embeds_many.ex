defmodule Example.EmbedsMany do
  import Ecto.Changeset

  def cast_embed_many(%Ecto.Changeset{} = changeset, field) do
    updated_changeset =
      changeset
      |> cast_embed(field)

    changes =
      updated_changeset
      |> get_change(field)

    updated_changeset
      |> update_embed(field, changes)
  end

  def update_embed(changeset, _field, nil), do: changeset

  def update_embed(changeset, field, changes) do
    altered_changesets =
      changes
      |> Enum.map(&alter_action/1)

    changeset
    |> put_embed(field, altered_changesets)
  end

  def alter_action(%Ecto.Changeset{action: :replace} = changeset) do
    %Ecto.Changeset{changeset | action: :update}
  end

  def alter_action(%Ecto.Changeset{action: _} = changeset), do: changeset
end
