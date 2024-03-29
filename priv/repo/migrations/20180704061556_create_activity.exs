defmodule Backer.Repo.Migrations.CreateActivity do
  use Ecto.Migration

  def change do
    create table(:activity) do
      add(:activity, :string)
      add(:user_id, references(:user, on_delete: :delete_all))

      timestamps()
    end

    create(index(:activity, [:user_id]))
  end
end
