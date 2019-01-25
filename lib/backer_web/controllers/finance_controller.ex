defmodule BackerWeb.FinanceController do
  use BackerWeb, :controller

  # alias Backer.Constant
  alias Backer.Finance
  # alias Backer.Account

  def index(conn, params) do
    incoming = Finance.list_incoming_payments(%{"status" => "Approved"}, params)

    render(conn, "index.html", incoming: incoming)
  end

  def process(conn, %{"id" => id}) do
      incoming_payment = Finance.get_incoming_payment!(id)  
      changeset = Finance.change_incoming_payment(incoming_payment)
      render(conn, "edit.html", incoming_payment: incoming_payment,changeset: changeset) 
  end  

  def update(conn,  %{"id" => id, "incoming_payment" => params}) do
      user_id = conn.private.guardian_default_resource.id
      incoming_payment = Finance.get_incoming_payment!(id) 
    case Finance.process_incoming_payment(incoming_payment, Map.put(params, "excecutor_id", user_id)) do
      {:ok, _incoming_payment} ->
        conn
        |> put_flash(:info, "Incoming payment updated successfully.")
        |> redirect(to: finance_path(conn, :index))
      {:error, _any,%Ecto.Changeset{} = changeset, _} ->
        render(conn, "edit.html", changeset: changeset, incoming_payment: incoming_payment)
      {:error,%Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset, incoming_payment: incoming_payment)        
    end    
  end

end
