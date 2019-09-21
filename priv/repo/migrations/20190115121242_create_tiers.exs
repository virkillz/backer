defmodule Backer.Repo.Migrations.CreateTiers do
  use Ecto.Migration

  def change do
    create table(:tiers) do
      add(:title, :string)
      add(:description, :text)
      add(:amount, :integer)
      add(:donee_id, references(:donees, on_delete: :delete_all))

      timestamps()
    end

    create(index(:tiers, [:donee_id]))
  end
end
