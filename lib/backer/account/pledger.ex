defmodule Backer.Account.Pledger do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pledgers" do
    field(:account_id, :string)
    field(:account_name, :string)
    field(:background, :string)
    field(:bank_book_picture, :string)
    field(:bank_name, :string)
    field(:pledger_overview, :string)
    field(:status, :string)

    belongs_to :backer, {"backers", Backer.Account.Backer}
    belongs_to :category, {"categories", Backer.Masterdata.Category } 
    belongs_to :title, {"titles", Backer.Masterdata.Title }     

    timestamps()
  end

  @doc false
  def changeset(pledger, attrs) do
    pledger
    |> cast(attrs, [
      :background,
      :pledger_overview,
      :bank_name,
      :bank_book_picture,
      :account_name,
      :account_id,
      :status,
      :backer_id,
      :title_id,
      :category_id
    ])
    |> validate_required([
      :backer_id,
      :title_id,
      :category_id
    ])
    |> unique_constraint(:backer_id, [name: :pledgers_backers, message: "This backer already a Pledger"])
  end
end
