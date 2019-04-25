defmodule ExampleWeb.Api.TransactionsTest do
  use ExampleWeb.ConnCase, async: false

  @query %{"query" => "{transactions {description amount categoryId category { id name }}}"}
  @login %{username: "toran", password: "abcd1234"}

  @category_id_one "acbd18db4cc2f85cedef654fccc4a4d8"
  @category_one %{id: @category_id_one, name: "foo"}

  test "authentication required to query for transactions", %{conn: conn} do
    insert_categories([@category_one])

    request = post(conn, "/api", @query)
    assert redirected_to(request, 302) =~ "/"

    created = post(request, Routes.registration_path(conn, :create, @login))
    assert html_response(created, 302) =~ "redirected"

    denied = post(created, "/api", @query)
    assert redirected_to(denied, 302) =~ "/"

    authenticated = post(denied, Routes.login_path(conn, :create, @login))
    assert html_response(authenticated, 302) =~ "redirected"

    query_one = post(authenticated, "/api", @query)

    assert json_response(query_one, 200) == %{
             "data" => %{
               "transactions" => []
             }
           }

    mutation = %{
      "query" =>
        "mutation CreateTransaction { createTransaction(description: \"foo\", amount: 100, date: \"2019-01-01 01:00:00\", categoryId: \"#{
          @category_id_one
        }\") { id } }"
    }

    add_transaction = post(query_one, "/api", mutation)
    assert json_response(add_transaction, 200)

    query_two = post(add_transaction, "/api", @query)

    assert json_response(query_two, 200) == %{
             "data" => %{
               "transactions" => [
                 %{
                   "amount" => 100,
                   "description" => "foo",
                   "categoryId" => @category_id_one,
                   "category" => %{
                     "id" => @category_id_one,
                     "name" => "foo"
                   }
                 }
               ]
             }
           }

    logout = get(query_two, Routes.logout_path(conn, :index))
    assert html_response(logout, 302) =~ "redirected"

    denied_again = post(logout, "/api", @query)
    assert redirected_to(denied_again, 302) =~ "/"
  end

  defp insert_categories(categories) do
    Enum.each(categories, fn category ->
      Example.Categories.insert!(category)
    end)
  end
end
