defmodule BackerWeb.PledgerControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Account

  @create_attrs %{
    account_id: "some account_id",
    account_name: "some account_name",
    background: "some background",
    bank_book_picture: "some bank_book_picture",
    bank_name: "some bank_name",
    pledger_overview: "some pledger_overview",
    status: "some status"
  }
  @update_attrs %{
    account_id: "some updated account_id",
    account_name: "some updated account_name",
    background: "some updated background",
    bank_book_picture: "some updated bank_book_picture",
    bank_name: "some updated bank_name",
    pledger_overview: "some updated pledger_overview",
    status: "some updated status"
  }
  @invalid_attrs %{
    account_id: nil,
    account_name: nil,
    background: nil,
    bank_book_picture: nil,
    bank_name: nil,
    pledger_overview: nil,
    status: nil
  }

  def fixture(:pledger) do
    {:ok, pledger} = Account.create_pledger(@create_attrs)
    pledger
  end

  describe "index" do
    test "lists all pledgers", %{conn: conn} do
      conn = get(conn, pledger_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Pledgers"
    end
  end

  describe "new pledger" do
    test "renders form", %{conn: conn} do
      conn = get(conn, pledger_path(conn, :new))
      assert html_response(conn, 200) =~ "New Pledger"
    end
  end

  describe "create pledger" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, pledger_path(conn, :create), pledger: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == pledger_path(conn, :show, id)

      conn = get(conn, pledger_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Pledger"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, pledger_path(conn, :create), pledger: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Pledger"
    end
  end

  describe "edit pledger" do
    setup [:create_pledger]

    test "renders form for editing chosen pledger", %{conn: conn, pledger: pledger} do
      conn = get(conn, pledger_path(conn, :edit, pledger))
      assert html_response(conn, 200) =~ "Edit Pledger"
    end
  end

  describe "update pledger" do
    setup [:create_pledger]

    test "redirects when data is valid", %{conn: conn, pledger: pledger} do
      conn = put(conn, pledger_path(conn, :update, pledger), pledger: @update_attrs)
      assert redirected_to(conn) == pledger_path(conn, :show, pledger)

      conn = get(conn, pledger_path(conn, :show, pledger))
      assert html_response(conn, 200) =~ "some updated account_id"
    end

    test "renders errors when data is invalid", %{conn: conn, pledger: pledger} do
      conn = put(conn, pledger_path(conn, :update, pledger), pledger: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Pledger"
    end
  end

  describe "delete pledger" do
    setup [:create_pledger]

    test "deletes chosen pledger", %{conn: conn, pledger: pledger} do
      conn = delete(conn, pledger_path(conn, :delete, pledger))
      assert redirected_to(conn) == pledger_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, pledger_path(conn, :show, pledger))
      end)
    end
  end

  defp create_pledger(_) do
    pledger = fixture(:pledger)
    {:ok, pledger: pledger}
  end
end
