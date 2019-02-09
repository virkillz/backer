defmodule Backer.Account.Pledger do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backer.Masterdata

  schema "pledgers" do
    field(:account_id, :string)
    field(:account_name, :string)
    field(:background, :string)
    field(:bank_book_picture, :string)
    field(:bank_name, :string)
    field(:pledger_overview, :string)
    field(:status, :string)
    field(:featured_post, :id)
    field(:address_public, :string)
    field(:video_profile, :string)

    belongs_to(:backer, {"backers", Backer.Account.Backer})
    belongs_to(:category, {"categories", Backer.Masterdata.Category})
    belongs_to(:title, {"titles", Backer.Masterdata.Title})
    has_many(:tier, {"tiers", Backer.Masterdata.Tier})

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
      :category_id,
      :featured_post,
      :address_public,
      :video_profile
    ])
    |> validate_required([
      :backer_id,
      :title_id,
      :category_id
    ])
    |> unique_constraint(:backer_id,
      name: :pledgers_backers,
      message: "This backer already a Pledger"
    )
    |> add_background
  end

  defp add_background(changeset) do
    background = get_field(changeset, :background)
    title_id = get_field(changeset, :title_id)

    if title_id == nil do
      changeset
    else
      title = Masterdata.get_title!(title_id)

      case background do
        nil -> changeset |> change(background: title.default_background)
        "" -> changeset |> change(username: title.default_background)
        other -> changeset
      end
    end
  end
end
