defmodule Backer.Repo.Migrations.CreateForums do
  use Ecto.Migration

  def change do
    create table(:forums) do
      add(:title, :string)
      add(:content, :text)
      add(:is_visible, :boolean, default: false, null: false)
      add(:status, :string)
      add(:like_count, :integer)
      add(:donee_id, references(:donees, on_delete: :delete_all))
      add(:backer_id, references(:backers, on_delete: :delete_all))

      timestamps()
    end

    create(index(:forums, [:donee_id]))
    create(index(:forums, [:backer_id]))
  end
end
