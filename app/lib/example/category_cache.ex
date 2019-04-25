defmodule Example.CategoryCache do

  @table :categories_cache

  def insert(categories) do
    Enum.each(categories, fn(%Example.Category{id: id, name: name}) ->
      Cachex.put(@table, id, name)
    end)
  end

  def all do
    query = Cachex.Query.create(true, { :key, :value })
    categories = Cachex.stream!(@table, query) |> Enum.to_list
    Enum.map(categories, fn({id, name}) ->
     %{id: id, name: name}
    end)
  end

end
