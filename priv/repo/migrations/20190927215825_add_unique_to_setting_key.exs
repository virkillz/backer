defmodule Backer.Repo.Migrations.AddUniqueToSettingKey do
  use Ecto.Migration

  def change do
    create(unique_index(:general_settings, [:key]))
  end
end
