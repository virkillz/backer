defmodule Backer.Repo.Migrations.AddSettlementInfoToInvoice do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      add(:settlement_status, :string)
      add(:settlement_id, references(:settlements, on_delete: :nilify_all))
    end

    create(index(:invoices, [:settlement_id]))
  end
end
