defmodule Example.CategoryCache do
  @table :categories_table

  def create do
    :ets.new(@table, [:named_table, :set, :public, read_concurrency: true])
  end

  def insert(categories) do
    Enum.each(categories, fn %Example.Category{id: id, name: name} ->
      :ets.insert(@table, {id, name})
    end)
  end

  def all do
    categories = :ets.match(@table, {:"$1", :"$2"})

    Enum.map(categories, fn [id, name] ->
      %{id: id, name: name}
    end)
  end
end
