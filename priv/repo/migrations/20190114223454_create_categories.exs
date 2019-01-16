defmodule Backer.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :description, :text
      add :background, :string
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
