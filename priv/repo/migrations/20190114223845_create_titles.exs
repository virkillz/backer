defmodule Backer.Repo.Migrations.CreateTitles do
  use Ecto.Migration

  def change do
    create table(:titles) do
      add(:name, :string)
      add(:description, :text)
      add(:is_active, :boolean, default: false, null: false)
      add(:default_background, :string)
      timestamps()
    end
  end
end
