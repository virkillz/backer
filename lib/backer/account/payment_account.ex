defmodule Backer.Account.PaymentAccount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payment_accounts" do
    field :account_holder_name, :string
    field :account_number, :string
    field :branch, :string
    field :email_ref, :string
    field :other_ref, :string
    field :ownership_evidence, :string
    field :phone_ref, :string
    field :type, :string
    field :bank_id, :id
    field :backer_id, :id

    timestamps()
  end

  @doc false
  def changeset(payment_account, attrs) do
    payment_account
    |> cast(attrs, [:account_holder_name, :account_number, :branch, :type, :email_ref, :phone_ref, :other_ref, :ownership_evidence])
    |> validate_required([:account_holder_name, :account_number, :branch, :type, :email_ref, :phone_ref, :other_ref, :ownership_evidence])
    |> unique_constraint(:account_number)
  end
end
