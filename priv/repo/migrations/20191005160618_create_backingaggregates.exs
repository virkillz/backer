defmodule Backer.Repo.Migrations.CreateBackingaggregates do
  use Ecto.Migration

  def change do
    create table(:backingaggregates) do
      add(:last_amount, :integer)
      add(:last_tier, :string)
      add(:backing_status, :string)
      add(:accumulative_donation, :integer)
      add(:score, :integer)
      add(:backer_since, :naive_datetime)
      add(:backer_id, references(:backers, on_delete: :delete_all))
      add(:donee_id, references(:donees, on_delete: :delete_all))

      timestamps()
    end

    create(index(:backingaggregates, [:backer_id]))
    create(index(:backingaggregates, [:donee_id]))

    create(
      unique_index(:backingaggregates, [:backer_id, :donee_id], name: :backer_donee_unique_index)
    )
  end
end
