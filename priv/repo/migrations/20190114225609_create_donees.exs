defmodule Backer.Repo.Migrations.CreateDonees do
  use Ecto.Migration

  def change do
    create table(:donees) do
      add(:background, :string)
      add(:donee_overview, :text)
      add(:bank_name, :string)
      add(:bank_book_picture, :string)
      add(:account_name, :string)
      add(:account_id, :string)
      add(:status, :string)
      add(:tagline, :string)
      add(:is_listed, :boolean, default: false, null: false)
      add(:is_searchable, :boolean, default: true, null: false)
      add(:address_public, :string)
      add(:video_profile, :string)
      add(:backer_id, references(:backers, on_delete: :delete_all))
      add(:category_id, references(:categories, on_delete: :delete_all))
      add(:title_id, references(:titles, on_delete: :delete_all))

      timestamps()
    end

    create(index(:donees, [:backer_id]))
    create(index(:donees, [:category_id]))
    create(index(:donees, [:title_id]))
    # create unique_index(:donees, [:backer_id])
  end
end
