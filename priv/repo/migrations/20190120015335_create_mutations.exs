defmodule Backer.Repo.Migrations.CreateMutations do
  use Ecto.Migration

  def change do
    create table(:mutations) do
      add :asset, :string
      add :backer_id_string, :string
      add :debit, :integer
      add :credit, :integer
      add :frozen_amount, :integer
      add :balance, :integer
      add :action_type, :string
      add :reason, :string
      add :ref_id, :integer
      add :backer_id, references(:backers, [column: :id, on_delete: :nilify_all])
      add :action_by, references(:user, [column: :id, on_delete: :nilify_all])
      add :approved_by, references(:user, [column: :id, on_delete: :nilify_all])

      timestamps()
    end

    create index(:mutations, [:backer_id])
    create index(:mutations, [:action_by])
    create index(:mutations, [:approved_by])
  end
end
