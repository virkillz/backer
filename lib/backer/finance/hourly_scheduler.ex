defmodule Backer.HourlyScheduler do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    # Schedule work to be performed at some point
    Backer.Finance.expiry_unpaid_invoice()
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    # Reschedule once more
    Backer.Finance.expiry_unpaid_invoice()
    {:noreply, state}
  end

  defp schedule_work() do
    # In 1 hours
    Process.send_after(self(), :work, 1 * 60 * 60 * 1000)
  end
end
