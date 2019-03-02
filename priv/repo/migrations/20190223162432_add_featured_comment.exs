defmodule Backer.Repo.Migrations.AddFeaturedComment do
  use Ecto.Migration

  def change do
    alter table(:pcomments) do
      add :is_featured, :boolean

    end
  end
end
