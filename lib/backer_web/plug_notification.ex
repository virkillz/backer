defmodule BackerWeb.Plugs.SetNotification do
  import Plug.Conn

  alias Backer.Finance

  def init(_params) do
  end

  def call(conn, _params) do
    approval_count = Finance.count_incoming_payment_approval()
    incoming_payment_count = Finance.count_incoming_payment_pending()

    conn
    |> assign(:approval_count, approval_count)
    |> assign(:incoming_payment_pending_count, incoming_payment_count)
  end
end
