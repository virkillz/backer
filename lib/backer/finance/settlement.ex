defmodule Backer.Finance.Settlement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "settlements" do
    field :amount, :integer
    field :evidence, :string
    field :method, :string
    field :net_amount, :integer
    field :platform_fee, :integer
    field :platform_fee_percentage, :integer
    field :status, :string
    field :tax, :integer
    field :transaction_date, :naive_datetime
    field :transaction_fee, :integer
    field :tx_id, :string
    field :payment_account_id, :id
    field :reviewer_id, :id
    field :backer_id, :id
    field :donee_id, :id

    timestamps()
  end

  @doc false
  def changeset(settlement, attrs) do
    settlement
    |> cast(attrs, [:method, :evidence, :tx_id, :transaction_date, :status, :amount, :tax, :platform_fee, :platform_fee_percentage, :transaction_fee, :net_amount])
    |> validate_required([:method, :evidence, :tx_id, :transaction_date, :status, :amount, :tax, :platform_fee, :platform_fee_percentage, :transaction_fee, :net_amount])
    |> unique_constraint(:tx_id)
  end
end
