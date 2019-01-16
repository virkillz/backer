defmodule Backer.Repo.Migrations.CreateGeneralSettings do
  use Ecto.Migration

  def change do
    create table(:general_settings) do
      add :group, :string
      add :key, :string
      add :value, :string

      timestamps()
    end

  end
end
