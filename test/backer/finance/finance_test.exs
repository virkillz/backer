defmodule Backer.FinanceTest do
  use Backer.DataCase

  alias Backer.Finance

  describe "invoices" do
    alias Backer.Finance.Invoice

    @valid_attrs %{amount: 42, method: "some method", status: "some status"}
    @update_attrs %{amount: 43, method: "some updated method", status: "some updated status"}
    @invalid_attrs %{amount: nil, method: nil, status: nil}

    def invoice_fixture(attrs \\ %{}) do
      {:ok, invoice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Finance.create_invoice()

      invoice
    end

    test "list_invoices/0 returns all invoices" do
      invoice = invoice_fixture()
      assert Finance.list_invoices() == [invoice]
    end

    test "get_invoice!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Finance.get_invoice!(invoice.id) == invoice
    end

    test "create_invoice/1 with valid data creates a invoice" do
      assert {:ok, %Invoice{} = invoice} = Finance.create_invoice(@valid_attrs)
      assert invoice.amount == 42
      assert invoice.method == "some method"
      assert invoice.status == "some status"
    end

    test "create_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_invoice(@invalid_attrs)
    end

    test "update_invoice/2 with valid data updates the invoice" do
      invoice = invoice_fixture()
      assert {:ok, invoice} = Finance.update_invoice(invoice, @update_attrs)
      assert %Invoice{} = invoice
      assert invoice.amount == 43
      assert invoice.method == "some updated method"
      assert invoice.status == "some updated status"
    end

    test "update_invoice/2 with invalid data returns error changeset" do
      invoice = invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_invoice(invoice, @invalid_attrs)
      assert invoice == Finance.get_invoice!(invoice.id)
    end

    test "delete_invoice/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Finance.delete_invoice(invoice)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_invoice!(invoice.id) end
    end

    test "change_invoice/1 returns a invoice changeset" do
      invoice = invoice_fixture()
      assert %Ecto.Changeset{} = Finance.change_invoice(invoice)
    end
  end
end
