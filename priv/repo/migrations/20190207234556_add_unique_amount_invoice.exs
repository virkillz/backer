defmodule Backer.Repo.Migrations.AddUniqueAmountInvoice do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      add :unique_amount, :integer

    end
  end
end
