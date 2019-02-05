defmodule Backer.Finance.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "donations" do
    field(:amount, :integer)
    field(:month, :integer)
    field(:tier, :integer)
    field(:year, :integer)
    field(:pledger_id, :id)
    field(:backer_id, :id)
    field(:invoice_id, :id)

    timestamps()
  end

  @doc false
  def changeset(donation, attrs) do
    donation
    |> cast(attrs, [:amount, :tier, :backer_id, :pledger_id, :invoice_id, :month, :year])
    |> validate_required([:amount, :tier, :backer_id, :pledger_id, :invoice_id, :month, :year])
  end
end
