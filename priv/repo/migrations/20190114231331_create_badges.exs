defmodule Backer.Repo.Migrations.CreateBadges do
  use Ecto.Migration

  def change do
    create table(:badges) do
      add(:title, :string)
      add(:icon, :string)
      add(:description, :text)
      add(:donee_id, references(:donees, on_delete: :delete_all))

      timestamps()
    end

    create(index(:badges, [:donee_id]))
  end
end
