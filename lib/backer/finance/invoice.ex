defmodule Backer.Finance.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backer.Account.Backer, as: Backerz
  alias Backer.Constant

  schema "invoices" do
    field(:amount, :integer)
    field(:method, :string)
    field(:status, :string, default: "unpaid")
    field(:type, :string)
    field(:donation, :integer)
    field(:donee_id, :integer)
    field(:month, :integer)
    field(:unique_amount, :integer, default: 0)

    belongs_to(:backer, Backerz)
    has_many(:invoice_detail, Backer.Finance.InvoiceDetail)

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:amount, :status, :method, :backer_id, :type])
    |> validate_number(:amount, greater_than_or_equal_to: Constant.minimum_deposit())
    |> validate_required([:amount, :status, :method, :backer_id, :type])
    |> validate_paid(invoice)
  end

  def change_status_changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end

  def donation_changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:amount, :method, :backer_id, :donee_id, :type, :month])
    |> validate_number(:amount, greater_than_or_equal_to: Constant.minimum_tier())
    |> validate_number(:month, greater_than_or_equal_to: 1)
    |> validate_required([:amount, :month, :donee_id, :backer_id])
    |> add_donation
    |> transform_donation_changeset
    |> add_unique_amount
  end

  def add_unique_amount(changeset) do
    changeset |> change(unique_amount: Enum.random(0..500))
  end

  def add_donation(changeset) do
    amount = get_field(changeset, :amount)
    changeset |> change(donation: amount)
  end

  def transform_donation_changeset(changeset) do
    amount = get_field(changeset, :amount)
    month = get_field(changeset, :month)
    changeset |> change(amount: month * amount)
  end

  defp validate_paid(changeset, invoice) do
    status = get_field(changeset, :status)

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
