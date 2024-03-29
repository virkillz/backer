defmodule Backer.Repo.Migrations.CreateBadgeMembers do
  use Ecto.Migration

  def change do
    create table(:badge_members) do
      add :award_date, :date
      add :backer_id, references(:backers, on_delete: :delete_all)
      add :badge_id, references(:badges, on_delete: :delete_all)

      timestamps()
    end

    create index(:badge_members, [:backer_id])
    create index(:badge_members, [:badge_id])
  end
end
