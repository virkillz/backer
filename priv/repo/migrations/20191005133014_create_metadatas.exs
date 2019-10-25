defmodule Backer.Repo.Migrations.CreateMetadatas do
  use Ecto.Migration

  def change do
    create table(:metadatas) do
      add(:group, :string)
      add(:key, :string)
      add(:value_integer, :integer)
      add(:value_string, :string)
      add(:value_boolean, :boolean, default: false, null: false)
      add(:backer_id, references(:backers, on_delete: :delete_all))

      timestamps()
    end

    create(index(:metadatas, [:backer_id]))
    create(index(:metadatas, [:key]))
  end
end
