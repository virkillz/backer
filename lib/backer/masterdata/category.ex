defmodule Backer.Masterdata.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field(:background, :string)
    field(:description, :string)
    field(:is_active, :boolean, default: false)
    field(:name, :string)

    timestamps()

    has_many(:donee, Backer.Account.Donee)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description, :background, :is_active])
    |> validate_required([:name])
  end
end
