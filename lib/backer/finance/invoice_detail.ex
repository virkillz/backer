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
    |> cast(attrs, [:amount, :year, :month, :type])
    |> validate_required([:amount, :year, :month, :type])
  end
end
