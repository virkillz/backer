defmodule Backer.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :amount, :integer
      add :status, :string
      add :method, :string
      add :backer_id, references(:backers, on_delete: :delete_all)

      timestamps()
    end

    create index(:invoices, [:backer_id])
  end
end
