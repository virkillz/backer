defmodule Backer.Repo.Migrations.AddCommentCountToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :comment_count, :integer
    end
  end
end
