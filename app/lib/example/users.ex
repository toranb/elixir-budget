defmodule Example.Users do
  import Ecto.Query, warn: false

  alias Example.Repo
  alias Example.User

  def all do
    Repo.all(User)
  end

  def get!(id) do
    Repo.get!(User, id)
  end

  def insert(changeset) do
    Repo.insert(changeset)
  end
end
