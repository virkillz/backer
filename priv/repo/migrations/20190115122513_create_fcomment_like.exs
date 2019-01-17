defmodule Backer.Repo.Migrations.CreateFcommentLike do
  use Ecto.Migration

  def change do
    create table(:fcomment_like) do
      add :fcomment_id, references(:fcomments, on_delete: :delete_all)
      add :backer_id, references(:backers, on_delete: :delete_all)

      timestamps()
    end

    create index(:fcomment_like, [:fcomment_id])
    create index(:fcomment_like, [:backer_id])
  end
end
