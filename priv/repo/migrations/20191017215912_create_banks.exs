defmodule Backer.Repo.Migrations.CreateBanks do
  use Ecto.Migration

  def change do
    create table(:banks) do
      add :name, :string
      add :remark, :text
      add :swift, :string
      add :code, :string
      add :address, :text
      add :branch, :string

      timestamps()
    end

    create unique_index(:banks, [:code])
  end
end
