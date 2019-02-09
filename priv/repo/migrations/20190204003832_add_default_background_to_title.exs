defmodule Backer.Repo.Migrations.AddDefaultBackgroundToTitle do
  use Ecto.Migration

  def change do
    alter table(:titles) do
      add :default_background, :string
    end
  end
end
