defmodule ExampleWeb.BudgetController do
  use ExampleWeb, :controller

  alias Example.Collection

  def index(conn, _params) do
    {:ok, categories} =
      Collection.all(:collection)
      |> Phoenix.json_library().encode()

    render(conn, "index.html", %{categories: categories})
  end
end
