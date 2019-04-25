defmodule ExampleWeb.BudgetControllerTest do
  use ExampleWeb.ConnCase

  alias Example.Categories

  @name "toran"
  @password "abcd1234"
  @login %{username: @name, password: @password}

  @id "acbd18db4cc2f85cedef654fccc4a4d8"
  @id_two "37b51d194a7513e45b56f6524f2d51f2"
  @category_one %{id: @id, name: "foo"}
  @category_two %{id: @id_two, name: "bar"}

  test "will preload all available categories", %{conn: conn} do
    insert_categories([@category_one, @category_two])
    register = post(conn, Routes.registration_path(conn, :create, @login))
    login = post(register, Routes.login_path(conn, :create, @login))
    budget = get(login, Routes.budget_path(conn, :index))

    assert String.match?(
             html_response(budget, 200),
             ~r/.*[{"id":"acbd18db4cc2f85cedef654fccc4a4d8","name":"foo"},{"id":"37b51d194a7513e45b56f6524f2d51f2","name":"bar"}].*/
           )
  end

  defp insert_categories(categories) do
    Enum.each(categories, fn category ->
      Categories.insert!(category)
    end)
  end
end
