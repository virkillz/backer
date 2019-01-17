defmodule Backer.Repo.Migrations.CreatePostLikes do
  use Ecto.Migration

  def change do
    create table(:post_likes) do
      add :post_id, references(:posts, on_delete: :delete_all)
      add :backer_id, references(:backers, on_delete: :delete_all)

      timestamps()
    end

    create index(:post_likes, [:post_id])
    create index(:post_likes, [:backer_id])
  end
end
