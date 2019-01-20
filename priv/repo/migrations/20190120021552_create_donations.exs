defmodule Backer.Repo.Migrations.CreateDonations do
  use Ecto.Migration

  def change do
    create table(:donations) do
      add :amount, :integer
      add :tier, :integer
      add :month, :integer
      add :year, :integer
      add :pledger_id, references(:pledgers, on_delete: :nilify_all)
      add :backer_id, references(:backers, on_delete: :nilify_all)
      add :invoice_id, references(:invoices, on_delete: :nilify_all)

      timestamps()
    end

    create index(:donations, [:pledger_id])
    create index(:donations, [:backer_id])
    create index(:donations, [:invoice_id])
  end
end
