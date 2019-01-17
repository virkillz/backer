defmodule Backer.Repo.Migrations.CreateFcomments do
  use Ecto.Migration

  def change do
    create table(:fcomments) do
      add :content, :text
      add :forum_id, references(:forums, on_delete: :delete_all)
      add :fcomment_id, references(:fcomments, on_delete: :delete_all)
      add :backer_id, references(:backers, on_delete: :delete_all)

      timestamps()
    end

    create index(:fcomments, [:forum_id])
    create index(:fcomments, [:fcomment_id])
    create index(:fcomments, [:backer_id])
  end
end
