defmodule Backer.Repo.Migrations.CreateInvoiceDetails do
  use Ecto.Migration

  def change do
    create table(:invoice_details) do
      add :amount, :integer
      add :year, :integer
      add :month, :integer
      add :type, :string
      add :backer_id, references(:backers, on_delete: :delete_all)
      add :invoice_id, references(:invoices, on_delete: :delete_all)
      add :pledger_id, references(:pledgers, on_delete: :nilify_all)

      timestamps()
    end

    create index(:invoice_details, [:backer_id])
    create index(:invoice_details, [:invoice_id])
    create index(:invoice_details, [:pledger_id])
  end
end
