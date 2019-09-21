defmodule Backer.Repo.Migrations.CreatePledgers do
  use Ecto.Migration

  def change do
    create table(:pledgers) do
      add(:background, :string)
      add(:pledger_overview, :text)
      add(:bank_name, :string)
      add(:bank_book_picture, :string)
      add(:account_name, :string)
      add(:account_id, :string)
      add(:status, :string)
      add(:address_public, :string)
      add(:video_profile, :string)
      add(:backer_id, references(:backers, on_delete: :delete_all))
      add(:category_id, references(:categories, on_delete: :delete_all))
      add(:title_id, references(:titles, on_delete: :delete_all))

      timestamps()
    end

    create(index(:pledgers, [:backer_id]))
    create(index(:pledgers, [:category_id]))
    create(index(:pledgers, [:title_id]))
    # create unique_index(:pledgers, [:backer_id])
  end
end
