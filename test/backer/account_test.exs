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
end
