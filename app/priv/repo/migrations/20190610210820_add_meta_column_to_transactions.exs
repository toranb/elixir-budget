defmodule Example.Repo.Migrations.AddMetaColumnToTransactions do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :meta, :map, null: true
    end
  end
end
