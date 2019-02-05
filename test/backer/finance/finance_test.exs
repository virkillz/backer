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

  describe "incoming_payments" do
    alias Backer.Finance.IncomingPayment

    @valid_attrs %{
      action: "some action",
      amount: 42,
      destination: "some destination",
      details: "some details",
      evidence: "some evidence",
      source: "some source",
      status: "some status",
      tx_id: "some tx_id"
    }
    @update_attrs %{
      action: "some updated action",
      amount: 43,
      destination: "some updated destination",
      details: "some updated details",
      evidence: "some updated evidence",
      source: "some updated source",
      status: "some updated status",
      tx_id: "some updated tx_id"
    }
    @invalid_attrs %{
      action: nil,
      amount: nil,
      destination: nil,
      details: nil,
      evidence: nil,
      source: nil,
      status: nil,
      tx_id: nil
    }

    def incoming_payment_fixture(attrs \\ %{}) do
      {:ok, incoming_payment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Finance.create_incoming_payment()

      incoming_payment
    end

    test "list_incoming_payments/0 returns all incoming_payments" do
      incoming_payment = incoming_payment_fixture()
      assert Finance.list_incoming_payments() == [incoming_payment]
    end

    test "get_incoming_payment!/1 returns the incoming_payment with given id" do
      incoming_payment = incoming_payment_fixture()
      assert Finance.get_incoming_payment!(incoming_payment.id) == incoming_payment
    end

    test "create_incoming_payment/1 with valid data creates a incoming_payment" do
      assert {:ok, %IncomingPayment{} = incoming_payment} =
               Finance.create_incoming_payment(@valid_attrs)

      assert incoming_payment.action == "some action"
      assert incoming_payment.amount == 42
      assert incoming_payment.destination == "some destination"
      assert incoming_payment.details == "some details"
      assert incoming_payment.evidence == "some evidence"
      assert incoming_payment.source == "some source"
      assert incoming_payment.status == "some status"
      assert incoming_payment.tx_id == "some tx_id"
    end

    test "create_incoming_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_incoming_payment(@invalid_attrs)
    end

    test "update_incoming_payment/2 with valid data updates the incoming_payment" do
      incoming_payment = incoming_payment_fixture()

      assert {:ok, incoming_payment} =
               Finance.update_incoming_payment(incoming_payment, @update_attrs)

      assert %IncomingPayment{} = incoming_payment
      assert incoming_payment.action == "some updated action"
      assert incoming_payment.amount == 43
      assert incoming_payment.destination == "some updated destination"
      assert incoming_payment.details == "some updated details"
      assert incoming_payment.evidence == "some updated evidence"
      assert incoming_payment.source == "some updated source"
      assert incoming_payment.status == "some updated status"
      assert incoming_payment.tx_id == "some updated tx_id"
    end

    test "update_incoming_payment/2 with invalid data returns error changeset" do
      incoming_payment = incoming_payment_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Finance.update_incoming_payment(incoming_payment, @invalid_attrs)

      assert incoming_payment == Finance.get_incoming_payment!(incoming_payment.id)
    end

    test "delete_incoming_payment/1 deletes the incoming_payment" do
      incoming_payment = incoming_payment_fixture()
      assert {:ok, %IncomingPayment{}} = Finance.delete_incoming_payment(incoming_payment)

      assert_raise Ecto.NoResultsError, fn ->
        Finance.get_incoming_payment!(incoming_payment.id)
      end
    end

    test "change_incoming_payment/1 returns a incoming_payment changeset" do
      incoming_payment = incoming_payment_fixture()
      assert %Ecto.Changeset{} = Finance.change_incoming_payment(incoming_payment)
    end
  end

  describe "invoice_details" do
    alias Backer.Finance.InvoiceDetail

    @valid_attrs %{amount: 42, month: 42, type: "some type", year: 42}
    @update_attrs %{amount: 43, month: 43, type: "some updated type", year: 43}
    @invalid_attrs %{amount: nil, month: nil, type: nil, year: nil}

    def invoice_detail_fixture(attrs \\ %{}) do
      {:ok, invoice_detail} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Finance.create_invoice_detail()

      invoice_detail
    end

    test "list_invoice_details/0 returns all invoice_details" do
      invoice_detail = invoice_detail_fixture()
      assert Finance.list_invoice_details() == [invoice_detail]
    end

    test "get_invoice_detail!/1 returns the invoice_detail with given id" do
      invoice_detail = invoice_detail_fixture()
      assert Finance.get_invoice_detail!(invoice_detail.id) == invoice_detail
    end

    test "create_invoice_detail/1 with valid data creates a invoice_detail" do
      assert {:ok, %InvoiceDetail{} = invoice_detail} =
               Finance.create_invoice_detail(@valid_attrs)

      assert invoice_detail.amount == 42
      assert invoice_detail.month == 42
      assert invoice_detail.type == "some type"
      assert invoice_detail.year == 42
    end

    test "create_invoice_detail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_invoice_detail(@invalid_attrs)
    end

    test "update_invoice_detail/2 with valid data updates the invoice_detail" do
      invoice_detail = invoice_detail_fixture()
      assert {:ok, invoice_detail} = Finance.update_invoice_detail(invoice_detail, @update_attrs)
      assert %InvoiceDetail{} = invoice_detail
      assert invoice_detail.amount == 43
      assert invoice_detail.month == 43
      assert invoice_detail.type == "some updated type"
      assert invoice_detail.year == 43
    end

    test "update_invoice_detail/2 with invalid data returns error changeset" do
      invoice_detail = invoice_detail_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Finance.update_invoice_detail(invoice_detail, @invalid_attrs)

      assert invoice_detail == Finance.get_invoice_detail!(invoice_detail.id)
    end

    test "delete_invoice_detail/1 deletes the invoice_detail" do
      invoice_detail = invoice_detail_fixture()
      assert {:ok, %InvoiceDetail{}} = Finance.delete_invoice_detail(invoice_detail)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_invoice_detail!(invoice_detail.id) end
    end

    test "change_invoice_detail/1 returns a invoice_detail changeset" do
      invoice_detail = invoice_detail_fixture()
      assert %Ecto.Changeset{} = Finance.change_invoice_detail(invoice_detail)
    end
  end

  describe "donations" do
    alias Backer.Finance.Donation

    @valid_attrs %{amount: 42, month: 42, tier: 42, year: 42}
    @update_attrs %{amount: 43, month: 43, tier: 43, year: 43}
    @invalid_attrs %{amount: nil, month: nil, tier: nil, year: nil}

    def donation_fixture(attrs \\ %{}) do
      {:ok, donation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Finance.create_donation()

      donation
    end

    test "list_donations/0 returns all donations" do
      donation = donation_fixture()
      assert Finance.list_donations() == [donation]
    end

    test "get_donation!/1 returns the donation with given id" do
      donation = donation_fixture()
      assert Finance.get_donation!(donation.id) == donation
    end

    test "create_donation/1 with valid data creates a donation" do
      assert {:ok, %Donation{} = donation} = Finance.create_donation(@valid_attrs)
      assert donation.amount == 42
      assert donation.month == 42
      assert donation.tier == 42
      assert donation.year == 42
    end

    test "create_donation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_donation(@invalid_attrs)
    end

    test "update_donation/2 with valid data updates the donation" do
      donation = donation_fixture()
      assert {:ok, donation} = Finance.update_donation(donation, @update_attrs)
      assert %Donation{} = donation
      assert donation.amount == 43
      assert donation.month == 43
      assert donation.tier == 43
      assert donation.year == 43
    end

    test "update_donation/2 with invalid data returns error changeset" do
      donation = donation_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_donation(donation, @invalid_attrs)
      assert donation == Finance.get_donation!(donation.id)
    end

    test "delete_donation/1 deletes the donation" do
      donation = donation_fixture()
      assert {:ok, %Donation{}} = Finance.delete_donation(donation)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_donation!(donation.id) end
    end

    test "change_donation/1 returns a donation changeset" do
      donation = donation_fixture()
      assert %Ecto.Changeset{} = Finance.change_donation(donation)
    end
  end

  describe "mutations" do
    alias Backer.Finance.Mutation

    @valid_attrs %{
      action_type: "some action_type",
      asset: "some asset",
      backer_id_string: "some backer_id_string",
      balance: 42,
      credit: 42,
      debit: 42,
      frozen_amount: 42,
      reason: "some reason",
      ref_id: 42
    }
    @update_attrs %{
      action_type: "some updated action_type",
      asset: "some updated asset",
      backer_id_string: "some updated backer_id_string",
      balance: 43,
      credit: 43,
      debit: 43,
      frozen_amount: 43,
      reason: "some updated reason",
      ref_id: 43
    }
    @invalid_attrs %{
      action_type: nil,
      asset: nil,
      backer_id_string: nil,
      balance: nil,
      credit: nil,
      debit: nil,
      frozen_amount: nil,
      reason: nil,
      ref_id: nil
    }

    def mutation_fixture(attrs \\ %{}) do
      {:ok, mutation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Finance.create_mutation()

      mutation
    end

    test "list_mutations/0 returns all mutations" do
      mutation = mutation_fixture()
      assert Finance.list_mutations() == [mutation]
    end

    test "get_mutation!/1 returns the mutation with given id" do
      mutation = mutation_fixture()
      assert Finance.get_mutation!(mutation.id) == mutation
    end

    test "create_mutation/1 with valid data creates a mutation" do
      assert {:ok, %Mutation{} = mutation} = Finance.create_mutation(@valid_attrs)
      assert mutation.action_type == "some action_type"
      assert mutation.asset == "some asset"
      assert mutation.backer_id_string == "some backer_id_string"
      assert mutation.balance == 42
      assert mutation.credit == 42
      assert mutation.debit == 42
      assert mutation.frozen_amount == 42
      assert mutation.reason == "some reason"
      assert mutation.ref_id == 42
    end

    test "create_mutation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_mutation(@invalid_attrs)
    end

    test "update_mutation/2 with valid data updates the mutation" do
      mutation = mutation_fixture()
      assert {:ok, mutation} = Finance.update_mutation(mutation, @update_attrs)
      assert %Mutation{} = mutation
      assert mutation.action_type == "some updated action_type"
      assert mutation.asset == "some updated asset"
      assert mutation.backer_id_string == "some updated backer_id_string"
      assert mutation.balance == 43
      assert mutation.credit == 43
      assert mutation.debit == 43
      assert mutation.frozen_amount == 43
      assert mutation.reason == "some updated reason"
      assert mutation.ref_id == 43
    end

    test "update_mutation/2 with invalid data returns error changeset" do
      mutation = mutation_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_mutation(mutation, @invalid_attrs)
      assert mutation == Finance.get_mutation!(mutation.id)
    end

    test "delete_mutation/1 deletes the mutation" do
      mutation = mutation_fixture()
      assert {:ok, %Mutation{}} = Finance.delete_mutation(mutation)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_mutation!(mutation.id) end
    end

    test "change_mutation/1 returns a mutation changeset" do
      mutation = mutation_fixture()
      assert %Ecto.Changeset{} = Finance.change_mutation(mutation)
    end
  end

  describe "withdrawals" do
    alias Backer.Finance.Withdrawal

    @valid_attrs %{
      amount: 42,
      fee: 42,
      net_ammount: 42,
      status: "some status",
      tx_details: "some tx_details",
      tx_id: "some tx_id",
      tx_image: "some tx_image"
    }
    @update_attrs %{
      amount: 43,
      fee: 43,
      net_ammount: 43,
      status: "some updated status",
      tx_details: "some updated tx_details",
      tx_id: "some updated tx_id",
      tx_image: "some updated tx_image"
    }
    @invalid_attrs %{
      amount: nil,
      fee: nil,
      net_ammount: nil,
      status: nil,
      tx_details: nil,
      tx_id: nil,
      tx_image: nil
    }

    def withdrawal_fixture(attrs \\ %{}) do
      {:ok, withdrawal} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Finance.create_withdrawal()

      withdrawal
    end

    test "list_withdrawals/0 returns all withdrawals" do
      withdrawal = withdrawal_fixture()
      assert Finance.list_withdrawals() == [withdrawal]
    end

    test "get_withdrawal!/1 returns the withdrawal with given id" do
      withdrawal = withdrawal_fixture()
      assert Finance.get_withdrawal!(withdrawal.id) == withdrawal
    end

    test "create_withdrawal/1 with valid data creates a withdrawal" do
      assert {:ok, %Withdrawal{} = withdrawal} = Finance.create_withdrawal(@valid_attrs)
      assert withdrawal.amount == 42
      assert withdrawal.fee == 42
      assert withdrawal.net_ammount == 42
      assert withdrawal.status == "some status"
      assert withdrawal.tx_details == "some tx_details"
      assert withdrawal.tx_id == "some tx_id"
      assert withdrawal.tx_image == "some tx_image"
    end

    test "create_withdrawal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_withdrawal(@invalid_attrs)
    end

    test "update_withdrawal/2 with valid data updates the withdrawal" do
      withdrawal = withdrawal_fixture()
      assert {:ok, withdrawal} = Finance.update_withdrawal(withdrawal, @update_attrs)
      assert %Withdrawal{} = withdrawal
      assert withdrawal.amount == 43
      assert withdrawal.fee == 43
      assert withdrawal.net_ammount == 43
      assert withdrawal.status == "some updated status"
      assert withdrawal.tx_details == "some updated tx_details"
      assert withdrawal.tx_id == "some updated tx_id"
      assert withdrawal.tx_image == "some updated tx_image"
    end

    test "update_withdrawal/2 with invalid data returns error changeset" do
      withdrawal = withdrawal_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_withdrawal(withdrawal, @invalid_attrs)
      assert withdrawal == Finance.get_withdrawal!(withdrawal.id)
    end

    test "delete_withdrawal/1 deletes the withdrawal" do
      withdrawal = withdrawal_fixture()
      assert {:ok, %Withdrawal{}} = Finance.delete_withdrawal(withdrawal)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_withdrawal!(withdrawal.id) end
    end

    test "change_withdrawal/1 returns a withdrawal changeset" do
      withdrawal = withdrawal_fixture()
      assert %Ecto.Changeset{} = Finance.change_withdrawal(withdrawal)
    end
  end
end
