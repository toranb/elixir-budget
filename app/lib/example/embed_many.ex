defmodule Example.EmbedMany do
  defstruct changeset: nil,
            field: nil,
            attrs: nil,
            struct_name: nil,
            module: nil,
            merged: nil,
            changes: nil,
            appended: nil,
            updated: nil

  def new(%Ecto.Changeset{} = changeset, field, attrs, %{__struct__: struct_name} = module) do
    %__MODULE__{
      changeset: changeset,
      field: field,
      attrs: attrs,
      struct_name: struct_name,
      module: module
    }
  end

  def merge(%__MODULE__{changeset: changeset, attrs: attrs, field: field} = struct) do
    list = Map.get(changeset.data, field, [])
    changes = Map.get(attrs, field, [])

    merged =
      list
      |> Enum.map(&Map.from_struct(&1))
      |> Enum.map(&merge_changes(&1, changes))

    %__MODULE__{struct | merged: merged, changes: changes}
  end

  def append(%__MODULE__{merged: merged, changes: changes} = struct) do
    newly_added =
      changes
      |> Enum.reject(fn item -> Map.get(item, :id, nil) != nil end)

    appended = merged ++ newly_added

    %__MODULE__{struct | appended: appended}
  end

  def apply_changeset(
        %__MODULE__{appended: appended, struct_name: struct_name, module: module} =
          struct
      ) do
    updated =
      appended
      |> Enum.map(fn attrs -> apply(struct_name, :changeset, [module, attrs]) end)

    %__MODULE__{struct | updated: updated}
  end

  def merge_changes(%{id: id} = item, changes) do
    case Enum.find(changes, fn change -> change.id === id end) do
      nil ->
        item

      match ->
        item
        |> Map.merge(match)
    end
  end
end
