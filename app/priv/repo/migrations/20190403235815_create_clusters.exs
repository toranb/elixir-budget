defmodule Example.Repo.Migrations.CreateClusters do
  use Ecto.Migration

  def change do
    create table(:clusters, primary_key: false) do
      add :id, :string, primary_key: true

      timestamps()
    end
  end
end
