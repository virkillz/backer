defmodule Backer.Masterdata.Bank do
  use Ecto.Schema
  import Ecto.Changeset

  schema "banks" do
    field :address, :string
    field :branch, :string
    field :code, :string
    field :name, :string
    field :remark, :string
    field :swift, :string

    timestamps()
  end

  @doc false
  def changeset(bank, attrs) do
    bank
    |> cast(attrs, [:name, :remark, :swift, :code, :address, :branch])
    |> validate_required([:name, :remark, :swift, :code, :address, :branch])
    |> unique_constraint(:code)
  end
end
