defmodule Example.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :description, :string, null: false
      add :amount, :integer, null: false
      add :date, :naive_datetime, null: false
      add :user_id, references(:users, type: :string, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:transactions, [:user_id])
  end
end
