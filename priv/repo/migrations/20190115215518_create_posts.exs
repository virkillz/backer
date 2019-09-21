defmodule Backer.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add(:like_count, :integer)
      add(:title, :string)
      add(:content, :text)
      add(:type, :string)
      add(:publish_status, :string)
      add(:min_tier, :integer)
      add(:featured_image, :string)
      add(:featured_link, :string)
      add(:featured_video, :string)
      add(:comment_count, :integer)
      add(:donee_id, references(:donees, on_delete: :delete_all))

      timestamps()
    end

    create(index(:posts, [:donee_id]))
  end
end
