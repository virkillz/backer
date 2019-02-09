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
    pledgers = Account.list_pledgers()
    changeset = Masterdata.change_tier(%Tier{})
    render(conn, "new.html", changeset: changeset, pledgers: pledgers)
  end

  def create(conn, %{"tier" => tier_params}) do
    case Masterdata.create_tier(tier_params) do
      {:ok, tier} ->
        conn
        |> put_flash(:info, "Tier created successfully.")
        |> redirect(to: tier_path(conn, :show, tier))

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
    pledgers = Account.list_pledgers()
    changeset = Masterdata.change_tier(tier)
    render(conn, "edit.html", tier: tier, pledgers: pledgers, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tier" => tier_params}) do
    tier = Masterdata.get_tier!(id)

    case Masterdata.update_tier(tier, tier_params) do
      {:ok, tier} ->
        conn
        |> put_flash(:info, "Tier updated successfully.")
        |> redirect(to: tier_path(conn, :show, tier))

      {:error, %Ecto.Changeset{} = changeset} ->
        pledgers = Account.list_pledgers()
        render(conn, "edit.html", tier: tier, pledgers: pledgers, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tier = Masterdata.get_tier!(id)
    {:ok, _tier} = Masterdata.delete_tier(tier)

    conn
    |> put_flash(:info, "Tier deleted successfully.")
    |> redirect(to: tier_path(conn, :index))
  end
end
