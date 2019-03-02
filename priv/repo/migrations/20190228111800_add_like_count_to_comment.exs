defmodule Backer.Repo.Migrations.AddLikeCountToComment do
  use Ecto.Migration

  def change do
    alter table(:pcomments) do
      add :like_count, :integer
    end
  end
end
