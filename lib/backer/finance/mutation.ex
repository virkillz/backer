defmodule Backer.Finance.Mutation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mutations" do
    field(:action_type, :string)
    field(:asset, :string)
    field(:backer_id_string, :string)
    field(:balance, :integer)
    field(:credit, :integer)
    field(:debit, :integer)
    field(:frozen_amount, :integer)
    field(:reason, :string)
    field(:ref_id, :integer)
    field(:backer_id, :id)
    field(:action_by, :id)
    field(:approved_by, :id)

    timestamps()
  end

  @doc false
  def changeset(mutation, attrs) do
    mutation
    |> cast(attrs, [
      :asset,
      :backer_id,
      :backer_id_string,
      :debit,
      :credit,
      :frozen_amount,
      :balance,
      :action_type,
      :reason,
      :ref_id,
      :action_by,
      :approved_by
    ])
    |> validate_required([:asset, :backer_id, :backer_id_string, :balance, :action_type, :reason])
  end
end
