defmodule BackerWeb.IncomingPaymentController do
  use BackerWeb, :controller

  alias Backer.Account
  alias Backer.Constant
  alias Backer.Finance
  alias Backer.Finance.IncomingPayment

  def index(conn, params) do
    new = Finance.list_new_incoming_payments()
    old = Finance.list_old_incoming_payments(params)    
    render(conn, "index.html", old: old, new: new)
  end

  def new(conn, _params) do
    unpaid_invoices = Finance.list_invoices(%{"status" => "not_paid"})
    statuses = Constant.incoming_payment_status
    actions = Constant.incoming_payment_action
    sources = Constant.incoming_payment_source
    destination = Constant.incoming_payment_destination
    changeset = Finance.change_incoming_payment(%IncomingPayment{})
    backers = Account.list_backers
    render(conn, "new.html", changeset: changeset, backers: backers, destination: destination, unpaid_invoices: unpaid_invoices, actions: actions, sources: sources, statuses: statuses)
  end

  def create(conn, %{"incoming_payment" => params}) do
    user_id = conn.private.guardian_default_resource.id

    incoming_payment_params =
    if params["status"] == "Approved" do
      params |> Map.put("maker_id", user_id) |> Map.put("checker_id", user_id)
    else
      params |> Map.put("maker_id", user_id)
    end

    case Finance.create_incoming_payment(incoming_payment_params) do
      {:ok, incoming_payment} ->
        conn
        |> put_flash(:info, "Incoming payment created successfully.")
        |> redirect(to: incoming_payment_path(conn, :show, incoming_payment))
      {:error, %Ecto.Changeset{} = changeset} ->
    unpaid_invoices = Finance.list_invoices(%{"status" => "not_paid"})
    statuses = Constant.incoming_payment_status
    actions = Constant.incoming_payment_action
    sources = Constant.incoming_payment_source
    destination = Constant.incoming_payment_destination
        backers = Account.list_backers
   render(conn, "new.html", changeset: changeset, backers: backers, destination: destination, unpaid_invoices: unpaid_invoices, actions: actions, sources: sources, statuses: statuses)
    end
  end

  def show(conn, %{"id" => id}) do
    incoming_payment = Finance.get_incoming_payment!(id)
    render(conn, "show.html", incoming_payment: incoming_payment)
  end

  def edit(conn, %{"id" => id}) do

          incoming_payment = Finance.get_incoming_payment!(id)

    if incoming_payment.status == "Executed" do
      
    conn
    |> put_flash(:error, "Executed incoming payment cannot be edited.")
    |> redirect(to: incoming_payment_path(conn, :index))  

    else
      unpaid_invoices = Finance.list_invoices(%{"status" => "not_paid"})
      statuses = Constant.incoming_payment_status
      actions = Constant.incoming_payment_action
      sources = Constant.incoming_payment_source  
      destination = Constant.incoming_payment_destination      
      changeset = Finance.change_incoming_payment(incoming_payment)
      backers = Account.list_backers
      render(conn, "edit.html", incoming_payment: incoming_payment, backers: backers, changeset: changeset, destination: destination, unpaid_invoices: unpaid_invoices, actions: actions, sources: sources, statuses: statuses)
      
    end

  end

  def update(conn, %{"id" => id, "incoming_payment" => params}) do
        user_id = conn.private.guardian_default_resource.id
    incoming_payment = Finance.get_incoming_payment!(id)
    incoming_payment_params =
    if params["status"] == "Approved" do
      params |> Map.put("maker_id", user_id) |> Map.put("checker_id", user_id)
    else
      params |> Map.put("maker_id", user_id)
    end    
    case Finance.update_incoming_payment(incoming_payment, incoming_payment_params) do
      {:ok, incoming_payment} ->
        conn
        |> put_flash(:info, "Incoming payment updated successfully.")
        |> redirect(to: incoming_payment_path(conn, :show, incoming_payment))
      {:error, %Ecto.Changeset{} = changeset} ->
        incoming_payment = Finance.get_incoming_payment!(id)
        unpaid_invoices = Finance.list_invoices(%{"status" => "not_paid"})
        statuses = Constant.incoming_payment_status
        actions = Constant.incoming_payment_action
        sources = Constant.incoming_payment_source    
        destination = Constant.incoming_payment_destination  
               backers = Account.list_backers
        render(conn, "edit.html", backers: backers, incoming_payment: incoming_payment, changeset: changeset, destination: destination, unpaid_invoices: unpaid_invoices, actions: actions, sources: sources, statuses: statuses)
    end
  end

  def delete(conn, %{"id" => id}) do
    incoming_payment = Finance.get_incoming_payment!(id)

    if incoming_payment.status == "Executed" do

    conn
    |> put_flash(:error, "Executed incoming payment cannot be deleted.")
    |> redirect(to: incoming_payment_path(conn, :index))  

    else

    {:ok, _incoming_payment} = Finance.delete_incoming_payment(incoming_payment)

    conn
    |> put_flash(:info, "Incoming payment deleted successfully.")
    |> redirect(to: incoming_payment_path(conn, :index))

  end
  end
end
