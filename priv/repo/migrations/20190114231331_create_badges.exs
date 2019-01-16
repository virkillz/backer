defmodule Backer.Repo.Migrations.CreateBadges do
  use Ecto.Migration

  def change do
    create table(:badges) do
      add :title, :string
      add :icon, :string
      add :description, :text
      add :pledger_id, references(:pledgers, on_delete: :nothing)

      timestamps()
    end

    create index(:badges, [:pledger_id])
  end
end
