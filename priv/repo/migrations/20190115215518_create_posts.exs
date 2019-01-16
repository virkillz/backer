defmodule Backer.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :like_count, :integer
      add :title, :string
      add :content, :text
      add :min_tier, :integer
      add :featured_image, :string
      add :featured_link, :string
      add :featured_video, :string
      add :pledger_id, references(:pledgers, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:pledger_id])
  end
end
