defmodule BackerWeb.Plugs.SetNotification do
  import Plug.Conn

  alias Backer.Finance

  def init(_params) do
  end

  def call(conn, _params) do

    approval_count = Finance.count_incoming_payment_approval

        conn
        |> assign(:approval_count, approval_count)

  end
end
