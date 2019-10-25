defmodule Backer.Repo.Migrations.CreateSettlements do
  use Ecto.Migration

  def change do
    create table(:settlements) do
      add :method, :string
      add :evidence, :string
      add :tx_id, :string
      add :transaction_date, :naive_datetime
      add :status, :string
      add :amount, :integer
      add :tax, :integer
      add :platform_fee, :integer
      add :platform_fee_percentage, :integer
      add :transaction_fee, :integer
      add :net_amount, :integer
      add :payment_account_id, references(:payment_accounts, on_delete: :nilify_all)
      add :reviewer_id, references(:user, on_delete: :nilify_all)
      add :backer_id, references(:backers, on_delete: :nilify_all)
      add :donee_id, references(:donees, on_delete: :nilify_all)

      timestamps()
    end

    create unique_index(:settlements, [:tx_id])
    create index(:settlements, [:payment_account_id])
    create index(:settlements, [:reviewer_id])
    create index(:settlements, [:backer_id])
    create index(:settlements, [:donee_id])
  end
end
