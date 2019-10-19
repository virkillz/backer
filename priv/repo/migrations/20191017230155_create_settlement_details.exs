defmodule Backer.Repo.Migrations.CreateSettlementDetails do
  use Ecto.Migration

  def change do
    create table(:settlement_details) do
      add(:amount, :integer)
      add(:remark, :string)
      add(:settlement_id, references(:settlements, on_delete: :delete_all))
      add(:invoice_id, references(:invoices, on_delete: :nothing))
      add(:donee_id, references(:donees, on_delete: :nothing))
      add(:backer_id, references(:backers, on_delete: :nothing))

      timestamps()
    end

    create(index(:settlement_details, [:settlement_id]))
    create(index(:settlement_details, [:invoice_id]))
    create(index(:settlement_details, [:donee_id]))
    create(index(:settlement_details, [:backer_id]))
  end
end
