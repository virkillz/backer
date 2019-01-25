defmodule BackerWeb.WithdrawalController do
  use BackerWeb, :controller

  alias Backer.Finance
  alias Backer.Finance.Withdrawal

  def index(conn, params) do
    withdrawals = Finance.list_withdrawals(params)
    render(conn, "index.html", withdrawals: withdrawals)
  end

  def new(conn, _params) do
    changeset = Finance.change_withdrawal(%Withdrawal{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"withdrawal" => withdrawal_params}) do
    case Finance.create_withdrawal(withdrawal_params) do
      {:ok, withdrawal} ->
        conn
        |> put_flash(:info, "Withdrawal created successfully.")
        |> redirect(to: withdrawal_path(conn, :show, withdrawal))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    withdrawal = Finance.get_withdrawal!(id)
    render(conn, "show.html", withdrawal: withdrawal)
  end

  def edit(conn, %{"id" => id}) do
    withdrawal = Finance.get_withdrawal!(id)
    changeset = Finance.change_withdrawal(withdrawal)
    render(conn, "edit.html", withdrawal: withdrawal, changeset: changeset)
  end

  def update(conn, %{"id" => id, "withdrawal" => withdrawal_params}) do
    withdrawal = Finance.get_withdrawal!(id)

    case Finance.update_withdrawal(withdrawal, withdrawal_params) do
      {:ok, withdrawal} ->
        conn
        |> put_flash(:info, "Withdrawal updated successfully.")
        |> redirect(to: withdrawal_path(conn, :show, withdrawal))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", withdrawal: withdrawal, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    withdrawal = Finance.get_withdrawal!(id)
    {:ok, _withdrawal} = Finance.delete_withdrawal(withdrawal)

    conn
    |> put_flash(:info, "Withdrawal deleted successfully.")
    |> redirect(to: withdrawal_path(conn, :index))
  end
end
