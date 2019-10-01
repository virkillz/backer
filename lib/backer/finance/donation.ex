defmodule Backer.Finance.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "donations" do
    field(:amount, :integer)
    field(:month, :integer)
    # field(:tier, :integer)
    field(:year, :integer)
    field(:is_executed, :boolean, default: true)
    field(:invoice_id, :id)

    belongs_to(:donee, Backer.Account.Donee)
    belongs_to(:backer, Backer.Account.Backer)
    belongs_to(:backer_tier, Backer.Masterdata.Tier, foreign_key: :tier)

    timestamps()
  end

  @doc false
  def changeset(donation, attrs) do
    donation
    |> cast(attrs, [:amount, :tier, :backer_id, :donee_id, :invoice_id, :month, :year])
    |> validate_required([:amount, :tier, :backer_id, :donee_id, :invoice_id, :month, :year])
  end
end
