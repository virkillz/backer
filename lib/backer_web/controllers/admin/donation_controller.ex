defmodule BackerWeb.DonationController do
  use BackerWeb, :controller

  alias Backer.Finance
  alias Backer.Finance.Donation

  def index(conn, params) do
    donations = Finance.list_donations(params)
    render(conn, "index.html", donations: donations)
  end

  def new(conn, _params) do
    changeset = Finance.change_donation(%Donation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"donation" => donation_params}) do
    case Finance.create_donation(donation_params) do
      {:ok, donation} ->
        conn
        |> put_flash(:info, "Donation created successfully.")
        |> redirect(to: Router.donation_path(conn, :show, donation))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    donation = Finance.get_donation!(id)
    render(conn, "show.html", donation: donation)
  end

  def edit(conn, %{"id" => id}) do
    donation = Finance.get_donation!(id)
    changeset = Finance.change_donation(donation)
    render(conn, "edit.html", donation: donation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "donation" => donation_params}) do
    donation = Finance.get_donation!(id)

    case Finance.update_donation(donation, donation_params) do
      {:ok, donation} ->
        conn
        |> put_flash(:info, "Donation updated successfully.")
        |> redirect(to: Router.donation_path(conn, :show, donation))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", donation: donation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    donation = Finance.get_donation!(id)
    {:ok, _donation} = Finance.delete_donation(donation)

    conn
    |> put_flash(:info, "Donation deleted successfully.")
    |> redirect(to: Router.donation_path(conn, :index))
  end
end
