defmodule Backer.FinanceTest do
  use Backer.DataCase

  alias Backer.Finance

  describe "settlements" do
    alias Backer.Finance.Settlement

    @valid_attrs %{amount: 42, evidence: "some evidence", method: "some method", net_amount: 42, platform_fee: 42, platform_fee_percentage: 42, status: "some status", tax: 42, transaction_date: ~N[2010-04-17 14:00:00], transaction_fee: 42, tx_id: "some tx_id"}
    @update_attrs %{amount: 43, evidence: "some updated evidence", method: "some updated method", net_amount: 43, platform_fee: 43, platform_fee_percentage: 43, status: "some updated status", tax: 43, transaction_date: ~N[2011-05-18 15:01:01], transaction_fee: 43, tx_id: "some updated tx_id"}
    @invalid_attrs %{amount: nil, evidence: nil, method: nil, net_amount: nil, platform_fee: nil, platform_fee_percentage: nil, status: nil, tax: nil, transaction_date: nil, transaction_fee: nil, tx_id: nil}

    def settlement_fixture(attrs \\ %{}) do
      {:ok, settlement} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Finance.create_settlement()

      settlement
    end

    test "list_settlements/0 returns all settlements" do
      settlement = settlement_fixture()
      assert Finance.list_settlements() == [settlement]
    end

    test "get_settlement!/1 returns the settlement with given id" do
      settlement = settlement_fixture()
      assert Finance.get_settlement!(settlement.id) == settlement
    end

    test "create_settlement/1 with valid data creates a settlement" do
      assert {:ok, %Settlement{} = settlement} = Finance.create_settlement(@valid_attrs)
      assert settlement.amount == 42
      assert settlement.evidence == "some evidence"
      assert settlement.method == "some method"
      assert settlement.net_amount == 42
      assert settlement.platform_fee == 42
      assert settlement.platform_fee_percentage == 42
      assert settlement.status == "some status"
      assert settlement.tax == 42
      assert settlement.transaction_date == ~N[2010-04-17 14:00:00]
      assert settlement.transaction_fee == 42
      assert settlement.tx_id == "some tx_id"
    end

    test "create_settlement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_settlement(@invalid_attrs)
    end

    test "update_settlement/2 with valid data updates the settlement" do
      settlement = settlement_fixture()
      assert {:ok, %Settlement{} = settlement} = Finance.update_settlement(settlement, @update_attrs)
      assert settlement.amount == 43
      assert settlement.evidence == "some updated evidence"
      assert settlement.method == "some updated method"
      assert settlement.net_amount == 43
      assert settlement.platform_fee == 43
      assert settlement.platform_fee_percentage == 43
      assert settlement.status == "some updated status"
      assert settlement.tax == 43
      assert settlement.transaction_date == ~N[2011-05-18 15:01:01]
      assert settlement.transaction_fee == 43
      assert settlement.tx_id == "some updated tx_id"
    end

    test "update_settlement/2 with invalid data returns error changeset" do
      settlement = settlement_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_settlement(settlement, @invalid_attrs)
      assert settlement == Finance.get_settlement!(settlement.id)
    end

    test "delete_settlement/1 deletes the settlement" do
      settlement = settlement_fixture()
      assert {:ok, %Settlement{}} = Finance.delete_settlement(settlement)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_settlement!(settlement.id) end
    end

    test "change_settlement/1 returns a settlement changeset" do
      settlement = settlement_fixture()
      assert %Ecto.Changeset{} = Finance.change_settlement(settlement)
    end
  end

  describe "settlement_details" do
    alias Backer.Finance.SettlementDetail

    @valid_attrs %{amount: 42, remark: "some remark"}
    @update_attrs %{amount: 43, remark: "some updated remark"}
    @invalid_attrs %{amount: nil, remark: nil}

    def settlement_detail_fixture(attrs \\ %{}) do
      {:ok, settlement_detail} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Finance.create_settlement_detail()

      settlement_detail
    end

    test "list_settlement_details/0 returns all settlement_details" do
      settlement_detail = settlement_detail_fixture()
      assert Finance.list_settlement_details() == [settlement_detail]
    end

    test "get_settlement_detail!/1 returns the settlement_detail with given id" do
      settlement_detail = settlement_detail_fixture()
      assert Finance.get_settlement_detail!(settlement_detail.id) == settlement_detail
    end

    test "create_settlement_detail/1 with valid data creates a settlement_detail" do
      assert {:ok, %SettlementDetail{} = settlement_detail} = Finance.create_settlement_detail(@valid_attrs)
      assert settlement_detail.amount == 42
      assert settlement_detail.remark == "some remark"
    end

    test "create_settlement_detail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_settlement_detail(@invalid_attrs)
    end

    test "update_settlement_detail/2 with valid data updates the settlement_detail" do
      settlement_detail = settlement_detail_fixture()
      assert {:ok, %SettlementDetail{} = settlement_detail} = Finance.update_settlement_detail(settlement_detail, @update_attrs)
      assert settlement_detail.amount == 43
      assert settlement_detail.remark == "some updated remark"
    end

    test "update_settlement_detail/2 with invalid data returns error changeset" do
      settlement_detail = settlement_detail_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_settlement_detail(settlement_detail, @invalid_attrs)
      assert settlement_detail == Finance.get_settlement_detail!(settlement_detail.id)
    end

    test "delete_settlement_detail/1 deletes the settlement_detail" do
      settlement_detail = settlement_detail_fixture()
      assert {:ok, %SettlementDetail{}} = Finance.delete_settlement_detail(settlement_detail)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_settlement_detail!(settlement_detail.id) end
    end

    test "change_settlement_detail/1 returns a settlement_detail changeset" do
      settlement_detail = settlement_detail_fixture()
      assert %Ecto.Changeset{} = Finance.change_settlement_detail(settlement_detail)
    end
  end
end
