defmodule Backer.Aggregate.BackingAggregate do
  use Ecto.Schema
  import Ecto.Changeset

  @doc """
  Backing aggregate is an aggregate where we summarize a backing history.
  one is created teh first time a backer backing a donee, and must be
  updated every beginning of the month, or everytime backer update,
  or extend donation.

  Oh, it also need to be updated each time application is restarted manually
  if the shutdown period pass 1st date of the month.
  """

  schema "backingaggregates" do
    field(:accumulative_donation, :integer)
    field(:backer_since, :naive_datetime)
    field(:backing_status, :string)
    field(:last_amount, :integer)
    field(:last_tier, :string)
    field(:score, :integer)
    field(:is_backer_anonymous, :boolean, default: false)
    field(:is_donee_anonymous, :boolean, default: false)

    belongs_to(:backer, {"backers", Backer.Account.Backer})
    belongs_to(:donee, {"donees", Backer.Account.Donee})
    timestamps()
  end

  @doc false
  def changeset(backing_aggregate, attrs) do
    backing_aggregate
    |> cast(attrs, [
      :last_amount,
      :last_tier,
      :backer_id,
      :is_donee_anonymous,
      :is_backer_anonymous,
      :donee_id,
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
