defmodule Backer.Finance.SettlementDetail do
  use Ecto.Schema
  import Ecto.Changeset

  schema "settlement_details" do
    field(:amount, :integer)
    field(:remark, :string)
    field(:settlement_id, :id)
    field(:invoice_id, :id)
    field(:donee_id, :id)
    field(:backer_id, :id)

    timestamps()
  end

  @doc false
  def changeset(settlement_detail, attrs) do
    settlement_detail
    |> cast(attrs, [:amount, :remark, :settlement_id, :invoice_id, :donee_id, :backer_id])
    |> validate_required([:amount, :remark, :settlement_id])
  end
end
