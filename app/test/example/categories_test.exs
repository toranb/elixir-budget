defmodule Example.CategoriesTest do
  use Example.DataCase, async: false

  alias Example.Repo
  alias Example.Category
  alias Example.Categories

  @id "acbd18db4cc2f85cedef654fccc4a4d8"
  @id_two "37b51d194a7513e45b56f6524f2d51f2"
  @category_one %{id: @id, name: "foo"}
  @category_two %{id: @id_two, name: "bar"}

  test "all will return any inserted category" do
    categories = Categories.all()
    assert Enum.count(categories) == 0

    insert_categories([@category_one, @category_two])

    categories = Categories.all()
    assert Enum.count(categories) == 2
    %Category{:name => name} = Enum.find(categories, fn(c) -> c.id == @id end)
    assert name == "foo"
    %Category{:name => name} = Enum.find(categories, fn(c) -> c.id == @id_two end)
    assert name == "bar"
  end

  test "changeset is invalid if category already exists" do
    %Category{}
      |> Category.changeset(@category_one)
      |> Repo.insert

    duplicate =
      %Category{}
      |> Category.changeset(@category_one)
    assert {:error, changeset} = Repo.insert(duplicate)
    refute changeset.valid?
    assert Map.get(changeset, :errors) == [id: {"category already exists", [constraint: :unique, constraint_name: "categories_pkey"]}]
  end

  defp insert_categories(categories) do
    Enum.each(categories, fn(category) ->
      %Category{}
        |> Category.changeset(category)
        |> Repo.insert
    end)
  end
end
