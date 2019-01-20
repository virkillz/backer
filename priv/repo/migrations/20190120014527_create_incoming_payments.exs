defmodule Backer.Repo.Migrations.CreateIncomingPayments do
  use Ecto.Migration

  def change do
    create table(:incoming_payments) do
      add :source, :string
      add :amount, :integer
      add :evidence, :string
      add :tx_id, :string
      add :status, :string
      add :action, :string
      add :details, :text
      add :destination, :string
      add :invoice_id, references(:invoices, on_delete: :delete_all)

      timestamps()
    end

    create index(:incoming_payments, [:invoice_id])
  end
end
