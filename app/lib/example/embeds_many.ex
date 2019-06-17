defmodule Example.EmbedsMany do
  import Ecto.Changeset

  def cast_embed_update(%Ecto.Changeset{} = changeset, field) do
    updated =
      changeset
      |> cast_embed(field, with: &Example.Number.changeset/2)

    numbers =
      updated.changes[field]
      |> Enum.map(fn changeset ->
        case changeset.action do
          :replace ->
            {:ok, applied} = apply_action(changeset, :update)

            changes =
              applied
              |> Map.from_struct()
              |> Map.delete(:id)

            %Ecto.Changeset{changeset | changes: changes, action: :update}

          _ ->
            changeset
        end
      end)

    %Ecto.Changeset{updated | changes: %{numbers: numbers}}
  end
end
