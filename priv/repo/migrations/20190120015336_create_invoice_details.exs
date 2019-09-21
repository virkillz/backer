defmodule Backer.Repo.Migrations.CreateInvoiceDetails do
  use Ecto.Migration

  def change do
    create table(:invoice_details) do
      add(:amount, :integer)
      add(:year, :integer)
      add(:month, :integer)
      add(:type, :string)
      add(:invoice_id, references(:invoices, on_delete: :delete_all))
      add(:donee_id, references(:donees, on_delete: :nilify_all))
      add(:is_settled, :boolean)
      add(:tier, :integer)
      add(:backer_id, references(:backers, on_delete: :nilify_all))
      add(:settlement_date, :date)
      add(:mutation_id, references(:mutations, on_delete: :nilify_all))
      add(:donation_id, references(:donations, on_delete: :nilify_all))

      timestamps()
    end

    create(index(:invoice_details, [:backer_id]))
    create(index(:invoice_details, [:invoice_id]))
    create(index(:invoice_details, [:donee_id]))
    create(index(:invoice_details, [:mutation_id]))
    create(index(:invoice_details, [:donation_id]))
  end
end
