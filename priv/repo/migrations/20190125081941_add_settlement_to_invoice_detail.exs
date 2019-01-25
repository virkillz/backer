defmodule Backer.Repo.Migrations.AddSettlementToInvoiceDetail do
  use Ecto.Migration

  def change do
    alter table(:invoice_details) do
      add :is_settled, :boolean
      add :settlement_date, :date
      add :mutation_id, references(:mutations, on_delete: :nilify_all)
      add :donation_id, references(:donations, on_delete: :nilify_all)

    end

    create index(:invoice_details, [:mutation_id]) 
    create index(:invoice_details, [:donation_id])        

  end
end
