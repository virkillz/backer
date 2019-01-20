defmodule Backer.Repo.Migrations.CreateWithdrawals do
  use Ecto.Migration

  def change do
    create table(:withdrawals) do
      add :amount, :integer
      add :fee, :integer
      add :net_ammount, :integer
      add :status, :string
      add :tx_image, :string
      add :tx_id, :string
      add :tx_details, :text
      add :backer_id, references(:backers, on_delete: :nilify_all)
      add :maker_id, references(:user, [column: :id, on_delete: :nilify_all])
      add :checker_id, references(:user, [column: :id, on_delete: :nilify_all])
      add :excecutor_id, references(:user, [column: :id, on_delete: :nilify_all])

      timestamps()
    end

    create index(:withdrawals, [:backer_id])
    create index(:withdrawals, [:maker_id])
    create index(:withdrawals, [:checker_id])
    create index(:withdrawals, [:excecutor_id])
  end
end
