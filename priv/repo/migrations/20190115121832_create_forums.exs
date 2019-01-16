defmodule Backer.Repo.Migrations.CreateForums do
  use Ecto.Migration

  def change do
    create table(:forums) do
      add :title, :string
      add :content, :text
      add :is_visible, :boolean, default: false, null: false
      add :status, :string
      add :like_count, :integer
      add :pledger_id, references(:pledgers, on_delete: :nothing)
      add :backer_id, references(:backers, on_delete: :nothing)

      timestamps()
    end

    create index(:forums, [:pledger_id])
    create index(:forums, [:backer_id])
  end
end
