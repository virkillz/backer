defmodule Backer.Repo.Migrations.CreateFcomments do
  use Ecto.Migration

  def change do
    create table(:fcomments) do
      add :content, :text
      add :forum_id, references(:forums, on_delete: :nothing)
      add :fcomment_id, references(:fcomments, on_delete: :nothing)
      add :backer_id, references(:backers, on_delete: :nothing)

      timestamps()
    end

    create index(:fcomments, [:forum_id])
    create index(:fcomments, [:fcomment_id])
    create index(:fcomments, [:backer_id])
  end
end
