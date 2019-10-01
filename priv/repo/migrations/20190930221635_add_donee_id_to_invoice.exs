defmodule Backer.Repo.Migrations.AddDoneeIdToInvoice do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      add(:donation, :integer)
      add(:donee_id, references(:donees, on_delete: :delete_all))
    end

    create(index(:invoices, [:donee_id]))
  end
end
