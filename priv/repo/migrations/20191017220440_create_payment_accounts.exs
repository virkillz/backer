defmodule Backer.Repo.Migrations.CreatePaymentAccounts do
  use Ecto.Migration

  def change do
    create table(:payment_accounts) do
      add :account_holder_name, :string
      add :account_number, :string
      add :branch, :string
      add :type, :string
      add :email_ref, :string
      add :phone_ref, :string
      add :other_ref, :string
      add :ownership_evidence, :string
      add :bank_id, references(:banks, on_delete: :nilify_all)
      add :backer_id, references(:backers, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:payment_accounts, [:account_number])
    create index(:payment_accounts, [:bank_id])
    create index(:payment_accounts, [:backer_id])
  end
end
