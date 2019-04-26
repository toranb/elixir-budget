defmodule Example.Categories do
  import Ecto.Query, warn: false

  alias Example.Repo
  alias Example.Category

  def all do
    Repo.all(Category)
  end

  def insert!(attrs \\ %{}) do
    Category
    |> struct(attrs)
    |> Repo.insert!()
  end
end
