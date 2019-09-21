defmodule Backer.Repo.Migrations.CreateIncomingPayments do
  use Ecto.Migration

  def change do
    create table(:incoming_payments) do
      add(:source, :string)
      add(:amount, :integer)
      add(:evidence, :string)
      add(:tx_id, :string)
      add(:status, :string)
      add(:action, :string)
      add(:details, :text)
      add(:destination, :string)
      add(:invoice_id, references(:invoices, column: :id, on_delete: :delete_all))
      add(:remark, :text)
      add(:backer_id, references(:backers, column: :id, on_delete: :nilify_all))
      add(:maker_id, references(:user, column: :id, on_delete: :nilify_all))
      add(:checker_id, references(:user, column: :id, on_delete: :nilify_all))
      add(:excecutor_id, references(:user, column: :id, on_delete: :nilify_all))

      timestamps()
    end

    create(index(:incoming_payments, [:invoice_id]))
  end
end
