defmodule Backer.Repo.Migrations.AddSomeColumnIncomingPayment do
  use Ecto.Migration

  def change do
    alter table(:incoming_payments) do
      add :remark, :text
      add :maker_id, references(:user, [column: :id, on_delete: :nilify_all])
      add :checker_id, references(:user, [column: :id, on_delete: :nilify_all])
      add :excecutor_id, references(:user, [column: :id, on_delete: :nilify_all])
    end
  end
end
