defmodule Backer.Repo.Migrations.CreateTiers do
  use Ecto.Migration

  def change do
    create table(:tiers) do
      add :title, :string
      add :description, :text
      add :amount, :integer
      add :pledger_id, references(:pledgers, on_delete: :delete_all)

      timestamps()
    end

    create index(:tiers, [:pledger_id])
  end
end
