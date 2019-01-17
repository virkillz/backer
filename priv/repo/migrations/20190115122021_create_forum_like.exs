defmodule Backer.Repo.Migrations.CreateForumLike do
  use Ecto.Migration

  def change do
    create table(:forum_like) do
      add :forum_id, references(:forums, on_delete: :delete_all)
      add :backer_id, references(:backers, on_delete: :delete_all)

      timestamps()
    end

    create index(:forum_like, [:forum_id])
    create index(:forum_like, [:backer_id])
  end
end
