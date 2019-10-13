defmodule Backer.Repo.Migrations.AddAnonymousOptionToBackingAggregate do
  use Ecto.Migration

  def change do
    alter table(:backingaggregates) do
      add(:is_backer_anonymous, :boolean)
      add(:is_donee_anonymous, :boolean)
    end
  end
end
