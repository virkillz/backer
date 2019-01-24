defmodule Backer.Finance.IncomingPayment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backer.Finance


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

  def changeset(incoming_payment, attrs) do
    incoming_payment
    |> cast(attrs, [:source, :amount, :evidence, :invoice_id, :tx_id, :status, :action, :remark, :maker_id, :checker_id, :excecutor_id,:details, :destination, :backer_id])
    |> validate_required([:source, :amount, :status, :action, :destination])
    |> validate_entry
    |> validate_not_yet_executed
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
        "Deposit" -> changeset |> put_change(:invoice_id, nil) |> validate_required([:backer_id])
        "Other" -> changeset |> put_change(:backer_id, nil) |> put_change(:invoice_id, nil)
        _ -> add_error(changeset,:status,"Something is wrong. Tell developer there's constant inconsistency")
      end
    end
  end

  defp validate_not_yet_executed(changeset) do
    status = get_field(changeset, :status)

    return =
    if status != "Executed" do
      changeset
    else
      add_error(changeset,:status,"This incoming payment cannot be edited because already executed")
    end
  end  

  @doc false
  def process_executed_other_changeset(incoming_payment, attrs) do
    incoming_payment
    |> cast(attrs, [:status,:remark, :excecutor_id])
    |> validate_required([:status, :remark, :excecutor_id])
  end 

  @doc false
  def process_revision_changeset(incoming_payment, attrs) do
    incoming_payment
    |> cast(attrs, [:status,:remark])
    |> validate_required([:status,:remark])
  end 

  def process_executed_deposit_changeset(incoming_payment, attrs) do
    incoming_payment
    |> cast(attrs, [:status, :excecutor_id])
    |> validate_required([:status, :excecutor_id])
    |> validate_backer_id_exist(incoming_payment)
  end

  def process_executed_settle_invoice_changeset(incoming_payment, attrs) do
    incoming_payment
    |> cast(attrs, [:status,:remark, :excecutor_id])
    |> validate_required([:status, :excecutor_id])
    |> validate_invoice_id_exist(incoming_payment)
    |> validate_invoice_exist(incoming_payment)
    |> validate_same_invoice_amount(incoming_payment)
  end  

  defp validate_backer_id_exist(changeset, incoming_payment) do
  result =
    if incoming_payment.backer_id == nil or incoming_payment.backer_id == "" do
      changeset |> add_error(:status,"Backer ID is empty on Incoming Payment")
    else
      changeset
    end
  end

  defp validate_same_invoice_amount(changeset, incoming_payment) do
     invoice = Finance.get_invoice!(incoming_payment.invoice_id) 

  result =
    if incoming_payment.amount != invoice.amount do
      changeset |> add_error(:status,"The invoice amount is not the same with incoming payment")
    else
      changeset
    end
  end

  defp validate_invoice_id_exist(changeset, incoming_payment) do
  result =
    if incoming_payment.invoice_id == nil or incoming_payment.invoice_id == "" do
      changeset |> add_error(changeset,:status,"Invoice ID is empty on Incoming Payment")
    else
      changeset
    end
  end

defp validate_invoice_exist(changeset, incoming_payment) do
  invoice = Finance.get_invoice!(incoming_payment.invoice_id) 
  result = 
  if invoice == nil do
    changeset |> add_error(:status,"Asscociated invoice cannot be founded")
  else
    if incoming_payment.amount != invoice.amount do
      changeset |> add_error(:status,"Invoice amount and Incoming Payment amount does not match")
    else 
      changeset
    end
  end
end


 defp validate_process(changeset) do
   changeset
 end


end
