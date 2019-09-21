defmodule Backer.Repo.Migrations.AddFeaturedPostToPledger do
  use Ecto.Migration

  def change do
    alter table(:pledgers) do
      add(:featured_post, references(:posts, on_delete: :nilify_all))
    end

    create(index(:pledgers, [:featured_post]))
  end
end
