defmodule Backer.Finance.Withdrawal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "withdrawals" do
    field(:amount, :integer)
    field(:fee, :integer)
    field(:net_ammount, :integer)
    field(:status, :string)
    field(:tx_details, :string)
    field(:tx_id, :string)
    field(:tx_image, :string)
    field(:backer_id, :id)
    field(:maker_id, :id)
    field(:checker_id, :id)
    field(:excecutor_id, :id)

    timestamps()
  end

  @doc false
  def changeset(withdrawal, attrs) do
    withdrawal
    |> cast(attrs, [:amount, :fee, :net_ammount, :status, :tx_image, :tx_id, :tx_details])
    |> validate_required([:amount, :fee, :net_ammount, :status, :tx_image, :tx_id, :tx_details])
  end
end
