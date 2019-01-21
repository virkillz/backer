defmodule Backer.Finance.InvoiceDetail do
  use Ecto.Schema
  import Ecto.Changeset


  schema "invoice_details" do
    field :amount, :integer
    field :month, :integer
    field :type, :string
    field :year, :integer
    field :backer_id, :id
    field :invoice_id, :id
    field :pledger_id, :id

    timestamps()
  end

  @doc false
  def changeset(invoice_detail, attrs) do
    invoice_detail
    |> cast(attrs, [:amount, :year, :month, :type, :backer_id, :pledger_id, :invoice_id])
    |> validate_required([:amount, :type, :backer_id, :invoice_id])
  end
end
