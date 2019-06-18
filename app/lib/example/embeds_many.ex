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

    updated_changeset
    |> put_embed(field, altered_changeset)
  end

  def alter_action(%Ecto.Changeset{action: :replace} = changeset) do
    %Ecto.Changeset{changeset | action: :update}
  end

  def alter_action(%Ecto.Changeset{action: _} = changeset), do: changeset
end
