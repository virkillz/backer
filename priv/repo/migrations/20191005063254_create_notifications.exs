defmodule Backer.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add(:type, :string)
      add(:content, :text)
      add(:is_read, :boolean, default: false, null: false)
      add(:other_ref_id, :integer)
      add(:additional_note, :string)
      add(:thumbnail, :string)
      add(:user_id, references(:backers, on_delete: :nothing))
      add(:backer_id, references(:backers, on_delete: :nothing))
      add(:donee_id, references(:donees, on_delete: :nothing))

      timestamps()
    end

    create(index(:notifications, [:user_id]))
    create(index(:notifications, [:backer_id]))
    create(index(:notifications, [:donee_id]))
  end
end
