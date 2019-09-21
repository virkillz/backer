defmodule Backer.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add(:amount, :integer)
      add(:status, :string)
      add(:method, :string)
      add(:unique_amount, :integer)
      add(:total, :integer)
      add(:type, :string)
      add(:backer_id, references(:backers, on_delete: :delete_all))

      timestamps()
    end

    create(index(:invoices, [:total]))
    create(index(:invoices, [:backer_id]))
  end
end
