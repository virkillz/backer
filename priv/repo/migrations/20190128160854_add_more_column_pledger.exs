defmodule Backer.Repo.Migrations.AddMoreColumnPledger do
  use Ecto.Migration

  def change do
    alter table(:pledgers) do
      add :featured_post, references(:posts, on_delete: :nilify_all)
      add :address_public, :string
      add :video_profile, :string 
  end

  create index(:pledgers, [:featured_post])
end
end
