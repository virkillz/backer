defmodule Backer.AccountTest do
  use Backer.DataCase

  alias Backer.Account

  describe "metadatas" do
    alias Backer.Account.Metadata

    @valid_attrs %{group: "some group", key: "some key", value_boolean: true, value_integer: 42, value_string: "some value_string"}
    @update_attrs %{group: "some updated group", key: "some updated key", value_boolean: false, value_integer: 43, value_string: "some updated value_string"}
    @invalid_attrs %{group: nil, key: nil, value_boolean: nil, value_integer: nil, value_string: nil}

    def metadata_fixture(attrs \\ %{}) do
      {:ok, metadata} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_metadata()

      metadata
    end

    test "list_metadatas/0 returns all metadatas" do
      metadata = metadata_fixture()
      assert Account.list_metadatas() == [metadata]
    end

    test "get_metadata!/1 returns the metadata with given id" do
      metadata = metadata_fixture()
      assert Account.get_metadata!(metadata.id) == metadata
    end

    test "create_metadata/1 with valid data creates a metadata" do
      assert {:ok, %Metadata{} = metadata} = Account.create_metadata(@valid_attrs)
      assert metadata.group == "some group"
      assert metadata.key == "some key"
      assert metadata.value_boolean == true
      assert metadata.value_integer == 42
      assert metadata.value_string == "some value_string"
    end

    test "create_metadata/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_metadata(@invalid_attrs)
    end

    test "update_metadata/2 with valid data updates the metadata" do
      metadata = metadata_fixture()
      assert {:ok, %Metadata{} = metadata} = Account.update_metadata(metadata, @update_attrs)
      assert metadata.group == "some updated group"
      assert metadata.key == "some updated key"
      assert metadata.value_boolean == false
      assert metadata.value_integer == 43
      assert metadata.value_string == "some updated value_string"
    end

    test "update_metadata/2 with invalid data returns error changeset" do
      metadata = metadata_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_metadata(metadata, @invalid_attrs)
      assert metadata == Account.get_metadata!(metadata.id)
    end

    test "delete_metadata/1 deletes the metadata" do
      metadata = metadata_fixture()
      assert {:ok, %Metadata{}} = Account.delete_metadata(metadata)
      assert_raise Ecto.NoResultsError, fn -> Account.get_metadata!(metadata.id) end
    end

    test "change_metadata/1 returns a metadata changeset" do
      metadata = metadata_fixture()
      assert %Ecto.Changeset{} = Account.change_metadata(metadata)
    end
  end

  describe "payment_accounts" do
    alias Backer.Account.PaymentAccount

    @valid_attrs %{account_holder_name: "some account_holder_name", account_number: "some account_number", branch: "some branch", email_ref: "some email_ref", other_ref: "some other_ref", ownership_evidence: "some ownership_evidence", phone_ref: "some phone_ref", type: "some type"}
    @update_attrs %{account_holder_name: "some updated account_holder_name", account_number: "some updated account_number", branch: "some updated branch", email_ref: "some updated email_ref", other_ref: "some updated other_ref", ownership_evidence: "some updated ownership_evidence", phone_ref: "some updated phone_ref", type: "some updated type"}
    @invalid_attrs %{account_holder_name: nil, account_number: nil, branch: nil, email_ref: nil, other_ref: nil, ownership_evidence: nil, phone_ref: nil, type: nil}

    def payment_account_fixture(attrs \\ %{}) do
      {:ok, payment_account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_payment_account()

      payment_account
    end

    test "list_payment_accounts/0 returns all payment_accounts" do
      payment_account = payment_account_fixture()
      assert Account.list_payment_accounts() == [payment_account]
    end

    test "get_payment_account!/1 returns the payment_account with given id" do
      payment_account = payment_account_fixture()
      assert Account.get_payment_account!(payment_account.id) == payment_account
    end

    test "create_payment_account/1 with valid data creates a payment_account" do
      assert {:ok, %PaymentAccount{} = payment_account} = Account.create_payment_account(@valid_attrs)
      assert payment_account.account_holder_name == "some account_holder_name"
      assert payment_account.account_number == "some account_number"
      assert payment_account.branch == "some branch"
      assert payment_account.email_ref == "some email_ref"
      assert payment_account.other_ref == "some other_ref"
      assert payment_account.ownership_evidence == "some ownership_evidence"
      assert payment_account.phone_ref == "some phone_ref"
      assert payment_account.type == "some type"
    end

    test "create_payment_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_payment_account(@invalid_attrs)
    end

    test "update_payment_account/2 with valid data updates the payment_account" do
      payment_account = payment_account_fixture()
      assert {:ok, %PaymentAccount{} = payment_account} = Account.update_payment_account(payment_account, @update_attrs)
      assert payment_account.account_holder_name == "some updated account_holder_name"
      assert payment_account.account_number == "some updated account_number"
      assert payment_account.branch == "some updated branch"
      assert payment_account.email_ref == "some updated email_ref"
      assert payment_account.other_ref == "some updated other_ref"
      assert payment_account.ownership_evidence == "some updated ownership_evidence"
      assert payment_account.phone_ref == "some updated phone_ref"
      assert payment_account.type == "some updated type"
    end

    test "update_payment_account/2 with invalid data returns error changeset" do
      payment_account = payment_account_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_payment_account(payment_account, @invalid_attrs)
      assert payment_account == Account.get_payment_account!(payment_account.id)
    end

    test "delete_payment_account/1 deletes the payment_account" do
      payment_account = payment_account_fixture()
      assert {:ok, %PaymentAccount{}} = Account.delete_payment_account(payment_account)
      assert_raise Ecto.NoResultsError, fn -> Account.get_payment_account!(payment_account.id) end
    end

    test "change_payment_account/1 returns a payment_account changeset" do
      payment_account = payment_account_fixture()
      assert %Ecto.Changeset{} = Account.change_payment_account(payment_account)
    end
  end
end
