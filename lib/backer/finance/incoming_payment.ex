defmodule Backer.Finance.IncomingPayment do
  use Ecto.Schema
  import Ecto.Changeset


  schema "incoming_payments" do
    field :action, :string
    field :amount, :integer
    field :destination, :string
    field :details, :string
    field :evidence, :string
    field :source, :string
    field :status, :string
    field :tx_id, :string
    field :invoice_id, :id

    timestamps()
  end

  @doc false
  def changeset(incoming_payment, attrs) do
    incoming_payment
    |> cast(attrs, [:source, :amount, :evidence, :tx_id, :status, :action, :details, :destination])
    |> validate_required([:source, :amount, :evidence, :tx_id, :status, :action, :details, :destination])
  end
end
