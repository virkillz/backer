defmodule BackerWeb.SettlementController do
  use BackerWeb, :controller

  alias Backer.Finance
  alias Backer.Finance.Settlement
  alias Backer.Account

  def index(conn, _params) do
    settlements = Finance.list_settlements()
    render(conn, "index.html", settlements: settlements)
  end

  def new(conn, _params) do
    donees = Finance.list_unsettled_donee()

    changeset = Finance.change_settlement(%Settlement{})
    render(conn, "new.html", changeset: changeset, donees: donees)
  end

  def build_settlement(conn, %{"id" => id}) do
    donee = Account.get_donee!(id)

    if not is_nil(donee) do
      unsettled_invoices = Finance.get_unsettled_donee(id)

      if Enum.count(unsettled_invoices) > 0 do
        amount = Enum.reduce(unsettled_invoices, 0, fn x, acc -> acc + x.amount end)

        attrs = %{"donee_id" => donee.id, "amount" => amount}

        changeset = Settlement.changeset(%Settlement{}, attrs)

        render(conn, "build.html",
          changeset: changeset,
          donee: donee,
          invoices: unsettled_invoices,
          amount: amount
        )
      else
        text(conn, "no invoice to be settled")
      end
    else
      conn
      |> put_status(:forbidden)
      |> text("not found.")
    end

    # jadi ada list invoice sama donee mana yang mau dipake.
  end

  def create(conn, %{"settlement" => settlement_params}) do
    case Finance.initiate_settlement(settlement_params) do
      {:ok, settlement} ->
        conn
        |> put_flash(:info, "Settlement created successfully.")
        |> redirect(to: Router.settlement_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        text(conn, "Failed to create settlement entry. Call virkill")
    end
  end

  def show(conn, %{"id" => id}) do
    settlement = Finance.get_settlement!(id)
    render(conn, "show.html", settlement: settlement)
  end

  def edit(conn, %{"id" => id}) do
    settlement = Finance.get_settlement!(id)

    changeset = Finance.change_settlement(settlement)
    render(conn, "edit.html", settlement: settlement, changeset: changeset)
  end

  def update(conn, %{"id" => id, "settlement" => settlement_params}) do
    settlement = Finance.get_settlement!(id)

    if settlement.status == "waiting payment" do
      new_params =
        settlement_params
        |> calculate_tax
        |> calculate_transaction_fee

      case Finance.update_settlement(settlement, new_params) do
        {:ok, settlement} ->
          conn
          |> put_flash(:info, "Settlement updated successfully.")
          |> redirect(to: Router.settlement_path(conn, :show, settlement))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", settlement: settlement, changeset: changeset)
      end
    else
      text(conn, "Sorry, cannot edit the paid settlement")
    end
  end

  def calculate_tax(params) do
    # if tax exist, deduct net_amount
    if params["tax"] != "" do
      new_amount = String.to_integer(params["net_amount"]) - String.to_integer(params["tax"])
      Map.put(params, "net_amount", "#{new_amount}")
    else
      params
    end
  end

  def calculate_transaction_fee(params) do
    # if transfer_fee exist, deduct net_amount
    if params["transaction_fee"] != "" do
      new_amount =
        String.to_integer(params["net_amount"]) - String.to_integer(params["transaction_fee"])

      Map.put(params, "net_amount", "#{new_amount}")
    else
      params
    end
  end

  def delete(conn, %{"id" => id}) do
    settlement = Finance.get_settlement!(id)
    {:ok, _settlement} = Finance.delete_settlement(settlement)

    conn
    |> put_flash(:info, "Settlement deleted successfully.")
    |> redirect(to: Router.settlement_path(conn, :index))
  end
end
