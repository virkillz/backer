defmodule BackerWeb.BankController do
  use BackerWeb, :controller

  alias Backer.Masterdata
  alias Backer.Masterdata.Bank

  def index(conn, _params) do
    banks = Masterdata.list_banks()
    render(conn, "index.html", banks: banks)
  end

  def new(conn, _params) do
    changeset = Masterdata.change_bank(%Bank{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bank" => bank_params}) do
    case Masterdata.create_bank(bank_params) do
      {:ok, bank} ->
        conn
        |> put_flash(:info, "Bank created successfully.")
        |> redirect(to: Router.bank_path(conn, :show, bank))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bank = Masterdata.get_bank!(id)
    render(conn, "show.html", bank: bank)
  end

  def edit(conn, %{"id" => id}) do
    bank = Masterdata.get_bank!(id)
    changeset = Masterdata.change_bank(bank)
    render(conn, "edit.html", bank: bank, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bank" => bank_params}) do
    bank = Masterdata.get_bank!(id)

    case Masterdata.update_bank(bank, bank_params) do
      {:ok, bank} ->
        conn
        |> put_flash(:info, "Bank updated successfully.")
        |> redirect(to: Router.bank_path(conn, :show, bank))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", bank: bank, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bank = Masterdata.get_bank!(id)
    {:ok, _bank} = Masterdata.delete_bank(bank)

    conn
    |> put_flash(:info, "Bank deleted successfully.")
    |> redirect(to: Router.bank_path(conn, :index))
  end
end
