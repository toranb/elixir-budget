defmodule Example.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string

      timestamps()
    end

    create unique_index(:categories, [:name])
  end
end
