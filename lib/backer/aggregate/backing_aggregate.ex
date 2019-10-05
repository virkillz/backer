defmodule Backer.Aggregate.BackingAggregate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "backingaggregates" do
    field(:accumulative_donation, :integer)
    field(:backer_since, :naive_datetime)
    field(:backing_status, :string)
    field(:last_amount, :integer)
    field(:last_tier, :string)
    field(:score, :integer)
    field(:backer_id, :id)
    field(:donee_id, :id)

    timestamps()
  end

  @doc false
  def changeset(backing_aggregate, attrs) do
    backing_aggregate
    |> cast(attrs, [
      :last_amount,
      :last_tier,
      :backing_status,
      :accumulative_donation,
      :score,
      :backer_since
    ])
    |> validate_required([
      :last_amount,
      :last_tier,
      :backing_status,
      :accumulative_donation,
      :score,
      :backer_since
    ])
    |> unique_constraint(:donee_id, name: :backer_donee_unique_index)
  end
end
