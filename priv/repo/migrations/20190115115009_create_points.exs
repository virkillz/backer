defmodule Backer.Repo.Migrations.CreatePoints do
  use Ecto.Migration

  def change do
    create table(:points) do
      add :point, :integer
      add :type, :string
      add :refference, :integer
      add :backer_id, references(:backers, on_delete: :nothing)
      add :pledger_id, references(:pledgers, on_delete: :nothing)

      timestamps()
    end

    create index(:points, [:backer_id])
    create index(:points, [:pledger_id])
  end
end
