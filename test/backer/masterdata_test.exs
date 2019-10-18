defmodule Backer.MasterdataTest do
  use Backer.DataCase

  alias Backer.Masterdata

  describe "banks" do
    alias Backer.Masterdata.Bank

    @valid_attrs %{address: "some address", branch: "some branch", code: "some code", name: "some name", remark: "some remark", swift: "some swift"}
    @update_attrs %{address: "some updated address", branch: "some updated branch", code: "some updated code", name: "some updated name", remark: "some updated remark", swift: "some updated swift"}
    @invalid_attrs %{address: nil, branch: nil, code: nil, name: nil, remark: nil, swift: nil}

    def bank_fixture(attrs \\ %{}) do
      {:ok, bank} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Masterdata.create_bank()

      bank
    end

    test "list_banks/0 returns all banks" do
      bank = bank_fixture()
      assert Masterdata.list_banks() == [bank]
    end

    test "get_bank!/1 returns the bank with given id" do
      bank = bank_fixture()
      assert Masterdata.get_bank!(bank.id) == bank
    end

    test "create_bank/1 with valid data creates a bank" do
      assert {:ok, %Bank{} = bank} = Masterdata.create_bank(@valid_attrs)
      assert bank.address == "some address"
      assert bank.branch == "some branch"
      assert bank.code == "some code"
      assert bank.name == "some name"
      assert bank.remark == "some remark"
      assert bank.swift == "some swift"
    end

    test "create_bank/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Masterdata.create_bank(@invalid_attrs)
    end

    test "update_bank/2 with valid data updates the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{} = bank} = Masterdata.update_bank(bank, @update_attrs)
      assert bank.address == "some updated address"
      assert bank.branch == "some updated branch"
      assert bank.code == "some updated code"
      assert bank.name == "some updated name"
      assert bank.remark == "some updated remark"
      assert bank.swift == "some updated swift"
    end

    test "update_bank/2 with invalid data returns error changeset" do
      bank = bank_fixture()
      assert {:error, %Ecto.Changeset{}} = Masterdata.update_bank(bank, @invalid_attrs)
      assert bank == Masterdata.get_bank!(bank.id)
    end

    test "delete_bank/1 deletes the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{}} = Masterdata.delete_bank(bank)
      assert_raise Ecto.NoResultsError, fn -> Masterdata.get_bank!(bank.id) end
    end

    test "change_bank/1 returns a bank changeset" do
      bank = bank_fixture()
      assert %Ecto.Changeset{} = Masterdata.change_bank(bank)
    end
  end
end
