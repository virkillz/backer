defmodule Backer.Finance.Settlement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "settlements" do
    field(:amount, :integer)
    field(:evidence, :string)
    field(:method, :string)
    field(:net_amount, :integer)
    field(:platform_fee, :integer)
    field(:platform_fee_percentage, :integer)
    field(:status, :string, default: "waiting payment")
    field(:tax, :integer)
    field(:transaction_date, :naive_datetime)
    field(:transaction_fee, :integer)
    field(:tx_id, :string)
    field(:payment_account_id, :id)
    field(:reviewer_id, :id)
    field(:backer_id, :id)

    belongs_to(:donee, {"donees", Backer.Account.Donee})

    timestamps()
  end

  @doc false
  def changeset_new(settlement, attrs) do
    settlement
    |> cast(attrs, [
      :donee_id,
      :amount,
      :net_amount,
      :platform_fee,
      :platform_fee_percentage,
      :status
    ])
    |> validate_required([
      :donee_id
    ])
  end

  @doc false
  def changeset(settlement, attrs) do
    settlement
    |> cast(attrs, [
      :method,
      :evidence,
      :tx_id,
      :donee_id,
      :transaction_date,
      :status,
      :amount,
      :tax,
      :platform_fee,
      :platform_fee_percentage,
      :transaction_fee,
      :net_amount
    ])
    |> validate_required([
      :method,
      :transaction_date,
      :status,
      :amount,
      :donee_id,
      :platform_fee,
      :platform_fee_percentage,
      :net_amount
    ])
    |> unique_constraint(:tx_id)
  end
end
