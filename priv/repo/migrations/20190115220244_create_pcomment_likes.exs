defmodule Backer.Repo.Migrations.CreatePcommentLikes do
  use Ecto.Migration

  def change do
    create table(:pcomment_likes) do
      add :pcomment_id, references(:pcomments, on_delete: :delete_all)
      add :backer_id, references(:backers, on_delete: :delete_all)

      timestamps()
    end

    create index(:pcomment_likes, [:pcomment_id])
    create index(:pcomment_likes, [:backer_id])
  end
end
