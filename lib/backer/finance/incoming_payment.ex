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
    field :backer_id, :id
    field :maker_id, :id
    field :checker_id, :id
    field :excecutor_id, :id
    field :remark, :string

    timestamps()
  end

  @doc false
  def changeset(incoming_payment, attrs) do
    incoming_payment
    |> cast(attrs, [:source, :amount, :evidence, :invoice_id, :tx_id, :status, :action, :remark, :maker_id, :checker_id, :excecutor_id,:details, :destination, :backer_id])
    |> validate_required([:source, :amount, :status, :action, :destination])
    |> validate_entry
  end

# case 1: if status not approved, cotinue to save, nothing to do.

# case 2: if status is approved, run validation: 
  # if action = manual deposit: the detail cannot be empty and must contain backer_id. invoice_id will be removed.
  # if action = invoice payment: the invoice_id cannto be empty and backer_id will be removed.
  # if action = other: do nothing. invoice_id and backer_id will be removed.

  defp validate_entry(changeset) do
    status = get_field(changeset, :status)
    action = get_field(changeset, :action)

    return =
    if status != "Approved" do
      changeset
    else
      case action do
        "Settle Invoice" -> changeset |> put_change(:backer_id, nil) |> validate_required([:invoice_id])
        "Manual Deposit" -> changeset |> put_change(:invoice_id, nil) |> validate_required([:backer_id])
        "Other" -> changeset |> put_change(:backer_id, nil) |> put_change(:invoice_id, nil)
        _ -> add_error(changeset,:status,"Something is wrong. Tell developer there's constant inconsistency")
      end
    end
  end

  @doc false
  def process_changeset(incoming_payment, attrs) do
    incoming_payment
    |> cast(attrs, [:status,:remark, :excecutor_id])
    |> validate_required([:status,:excecutor_id])
    |> validate_process
  end  


  #if status = revision request, pass changeset.
    # if status executed:
        # if action is "Other" do nothing.
        # if action is "manual deposit", validate backer_id not empty and fire command to deposit.
        # IF action is "Settle invoice", validate invoice_id is not empty and fire command to settle invoice. This is the hard part.

 defp validate_process(changeset) do
   changeset
 end


end
