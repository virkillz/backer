defmodule Backer.Repo.Migrations.AddBackerIdToIncomingPayment do
  use Ecto.Migration

  def change do
    alter table(:incoming_payments) do
      add :backer_id, references(:backers, on_delete: :nilify_all)
    end
  end
end
