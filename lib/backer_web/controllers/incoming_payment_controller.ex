defmodule BackerWeb.IncomingPaymentController do
  use BackerWeb, :controller

  alias Backer.Finance
  alias Backer.Finance.IncomingPayment

  def index(conn, _params) do
    incoming_payments = Finance.list_incoming_payments()
    render(conn, "index.html", incoming_payments: incoming_payments)
  end

  def new(conn, _params) do
    changeset = Finance.change_incoming_payment(%IncomingPayment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"incoming_payment" => incoming_payment_params}) do
    case Finance.create_incoming_payment(incoming_payment_params) do
      {:ok, incoming_payment} ->
        conn
        |> put_flash(:info, "Incoming payment created successfully.")
        |> redirect(to: incoming_payment_path(conn, :show, incoming_payment))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    incoming_payment = Finance.get_incoming_payment!(id)
    render(conn, "show.html", incoming_payment: incoming_payment)
  end

  def edit(conn, %{"id" => id}) do
    incoming_payment = Finance.get_incoming_payment!(id)
    changeset = Finance.change_incoming_payment(incoming_payment)
    render(conn, "edit.html", incoming_payment: incoming_payment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "incoming_payment" => incoming_payment_params}) do
    incoming_payment = Finance.get_incoming_payment!(id)

    case Finance.update_incoming_payment(incoming_payment, incoming_payment_params) do
      {:ok, incoming_payment} ->
        conn
        |> put_flash(:info, "Incoming payment updated successfully.")
        |> redirect(to: incoming_payment_path(conn, :show, incoming_payment))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", incoming_payment: incoming_payment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    incoming_payment = Finance.get_incoming_payment!(id)
    {:ok, _incoming_payment} = Finance.delete_incoming_payment(incoming_payment)

    conn
    |> put_flash(:info, "Incoming payment deleted successfully.")
    |> redirect(to: incoming_payment_path(conn, :index))
  end
end
