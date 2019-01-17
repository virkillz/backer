defmodule Backer.Repo.Migrations.CreatePcomments do
  use Ecto.Migration

  def change do
    create table(:pcomments) do
      add :content, :text
      add :post_id, references(:posts, on_delete: :delete_all)
      add :pcomment_id, references(:pcomments, on_delete: :delete_all)
      add :backer_id, references(:backers, on_delete: :delete_all)

      timestamps()
    end

    create index(:pcomments, [:post_id])
    create index(:pcomments, [:pcomment_id])
    create index(:pcomments, [:backer_id])
  end
end
