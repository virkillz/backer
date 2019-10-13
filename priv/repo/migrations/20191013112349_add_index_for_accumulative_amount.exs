defmodule Backer.Repo.Migrations.AddIndexForAccumulativeAmount do
  use Ecto.Migration

  def change do
    create(index(:backingaggregates, [:accumulative_donation]))
  end
end
