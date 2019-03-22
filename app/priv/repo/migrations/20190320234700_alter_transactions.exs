defmodule Example.Repo.Migrations.AlterTransactions do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :category_id, references(:categories, type: :string, on_delete: :nothing), null: true
    end
  end
end
