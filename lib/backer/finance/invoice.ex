defmodule Backer.Finance.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backer.Constant


  schema "invoices" do
    field :amount, :integer
    field :method, :string
    field :status, :string, [default: "unpaid"]
    field :backer_id, :id
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:amount, :status, :method, :backer_id, :type])
    |> validate_number(:amount, greater_than_or_equal_to: Constant.minimum_deposit)
    |> validate_required([:amount, :status, :method, :backer_id, :type])
    |> validate_paid(invoice)
  end


    defp validate_paid(changeset, invoice) do
    status = get_field(changeset, :status)
    return =
      case status != "paid" and invoice.status == "paid" do
        false ->
          changeset

        true ->
          add_error(
            changeset,
            :status,
            "Paid invoice cannot be changed."
          )
      end
  end

end
