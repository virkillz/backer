defmodule BackerWeb.TierController do
  use BackerWeb, :controller

  alias Backer.Account
  alias Backer.Masterdata
  alias Backer.Masterdata.Tier

  def index(conn, _params) do
    tiers = Masterdata.list_tiers()
    render(conn, "index.html", tiers: tiers)
  end

  def new(conn, _params) do
    donees = Account.list_donees()
    changeset = Masterdata.change_tier(%Tier{})
    render(conn, "new.html", changeset: changeset, donees: donees)
  end

  def create(conn, %{"tier" => tier_params}) do
    case Masterdata.create_tier(tier_params) do
      {:ok, tier} ->
        conn
        |> put_flash(:info, "Tier created successfully.")
        |> redirect(to: Router.tier_path(conn, :show, tier))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tier = Masterdata.get_tier!(id)
    render(conn, "show.html", tier: tier)
  end

  def edit(conn, %{"id" => id}) do
    tier = Masterdata.get_tier!(id)
    donees = Account.list_donees()
    changeset = Masterdata.change_tier(tier)
    render(conn, "edit.html", tier: tier, donees: donees, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tier" => tier_params}) do
    tier = Masterdata.get_tier!(id)

    case Masterdata.update_tier(tier, tier_params) do
      {:ok, tier} ->
        conn
        |> put_flash(:info, "Tier updated successfully.")
        |> redirect(to: Router.tier_path(conn, :show, tier))

      {:error, %Ecto.Changeset{} = changeset} ->
        donees = Account.list_donees()
        render(conn, "edit.html", tier: tier, donees: donees, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tier = Masterdata.get_tier!(id)
    {:ok, _tier} = Masterdata.delete_tier(tier)

    conn
    |> put_flash(:info, "Tier deleted successfully.")
    |> redirect(to: Router.tier_path(conn, :index))
  end
end
