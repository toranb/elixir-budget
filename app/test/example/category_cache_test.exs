defmodule Example.CategoryCacheTest do
  use Example.DataCase, async: true

  require Logger

  alias Example.Categories
  alias Example.CategoryCache

  @id "acbd18db4cc2f85cedef654fccc4a4d8"
  @id_two "37b51d194a7513e45b56f6524f2d51f2"
  @category_one %{id: @id, name: "foo"}
  @category_two %{id: @id_two, name: "bar"}

  test "insert all adds each category to ets" do
    create_ets_table()

    insert_categories([@category_one, @category_two])

    Categories.all() |> CategoryCache.insert()

    categories = CategoryCache.all()
    assert Enum.count(categories) == 2

    %{name: name} = Enum.find(categories, fn c -> c.id === @id end)
    assert name == "foo"
    %{name: name} = Enum.find(categories, fn c -> c.id === @id_two end)
    assert name == "bar"
  end

  defp create_ets_table do
    delete_ets_table()
    CategoryCache.create()
  rescue
    _ ->
      Logger.debug("create_ets_table failed")
  end

  defp delete_ets_table do
    :ets.delete_all_objects(:categories_table)
  rescue
    _ ->
      Logger.debug("delete_ets_table failed")
  end

  defp insert_categories(categories) do
    Enum.each(categories, fn category ->
      Categories.insert!(category)
    end)
  end
end
