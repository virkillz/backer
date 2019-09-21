defmodule Backer.Repo.Migrations.AddFeaturedPostToPledger do
  use Ecto.Migration

  def change do
    alter table(:donees) do
      add(:featured_post, references(:posts, on_delete: :nilify_all))
    end

    create(index(:donees, [:featured_post]))
  end
end
