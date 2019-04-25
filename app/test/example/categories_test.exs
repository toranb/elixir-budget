defmodule Example.CategoriesTest do
  use Example.DataCase, async: false

  alias Example.Category
  alias Example.Categories

  @id "acbd18db4cc2f85cedef654fccc4a4d8"
  @id_two "37b51d194a7513e45b56f6524f2d51f2"
  @category_one %{id: @id, name: "foo"}
  @category_two %{id: @id_two, name: "bar"}

  test "all will return any inserted category" do
    categories = Categories.all()
    assert Enum.empty?(categories)

    insert_categories([@category_one, @category_two])

    categories = Categories.all()
    assert Enum.count(categories) == 2
    %Category{:name => name} = Enum.find(categories, fn c -> c.id == @id end)
    assert name == "foo"
    %Category{:name => name} = Enum.find(categories, fn c -> c.id == @id_two end)
    assert name == "bar"
  end

  defp insert_categories(categories) do
    Enum.each(categories, fn category ->
      Categories.insert!(category)
    end)
  end
end
