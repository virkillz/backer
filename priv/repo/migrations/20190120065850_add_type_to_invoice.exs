defmodule Backer.Repo.Migrations.AddTypeToInvoice do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      add :type, :string
    end

  end
end
