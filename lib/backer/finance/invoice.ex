defmodule Backer.Finance.Invoice do
  use Ecto.Schema
  import Ecto.Changeset


  schema "invoices" do
    field :amount, :integer
    field :method, :string
    field :status, :string
    field :backer_id, :id

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:amount, :status, :method])
    |> validate_required([:amount, :status, :method])
  end
end
