defmodule BackerWeb.PaymentAccountController do
  use BackerWeb, :controller

  alias Backer.Account
  alias Backer.Account.PaymentAccount

  def index(conn, _params) do
    payment_accounts = Account.list_payment_accounts()
    render(conn, "index.html", payment_accounts: payment_accounts)
  end

  def new(conn, _params) do
    changeset = Account.change_payment_account(%PaymentAccount{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"payment_account" => payment_account_params}) do
    case Account.create_payment_account(payment_account_params) do
      {:ok, payment_account} ->
        conn
        |> put_flash(:info, "Payment account created successfully.")
        |> redirect(to: Router.payment_account_path(conn, :show, payment_account))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    payment_account = Account.get_payment_account!(id)
    render(conn, "show.html", payment_account: payment_account)
  end

  def edit(conn, %{"id" => id}) do
    payment_account = Account.get_payment_account!(id)
    changeset = Account.change_payment_account(payment_account)
    render(conn, "edit.html", payment_account: payment_account, changeset: changeset)
  end

  def update(conn, %{"id" => id, "payment_account" => payment_account_params}) do
    payment_account = Account.get_payment_account!(id)

    case Account.update_payment_account(payment_account, payment_account_params) do
      {:ok, payment_account} ->
        conn
        |> put_flash(:info, "Payment account updated successfully.")
        |> redirect(to: Router.payment_account_path(conn, :show, payment_account))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", payment_account: payment_account, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment_account = Account.get_payment_account!(id)
    {:ok, _payment_account} = Account.delete_payment_account(payment_account)

    conn
    |> put_flash(:info, "Payment account deleted successfully.")
    |> redirect(to: Router.payment_account_path(conn, :index))
  end
end
