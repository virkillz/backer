defmodule Backer.Repo.Migrations.AddTierToInvoiceDetail do
  use Ecto.Migration

  def change do
    alter table(:invoice_details) do
      add :tier, :integer

    end
  end
end
