defmodule BackerWeb.MetadataControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Account

  @create_attrs %{group: "some group", key: "some key", value_boolean: true, value_integer: 42, value_string: "some value_string"}
  @update_attrs %{group: "some updated group", key: "some updated key", value_boolean: false, value_integer: 43, value_string: "some updated value_string"}
  @invalid_attrs %{group: nil, key: nil, value_boolean: nil, value_integer: nil, value_string: nil}

  def fixture(:metadata) do
    {:ok, metadata} = Account.create_metadata(@create_attrs)
    metadata
  end

  describe "index" do
    test "lists all metadatas", %{conn: conn} do
      conn = get conn, metadata_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Metadatas"
    end
  end

  describe "new metadata" do
    test "renders form", %{conn: conn} do
      conn = get conn, metadata_path(conn, :new)
      assert html_response(conn, 200) =~ "New Metadata"
    end
  end

  describe "create metadata" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, metadata_path(conn, :create), metadata: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == metadata_path(conn, :show, id)

      conn = get conn, metadata_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Metadata"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, metadata_path(conn, :create), metadata: @invalid_attrs
      assert html_response(conn, 200) =~ "New Metadata"
    end
  end

  describe "edit metadata" do
    setup [:create_metadata]

    test "renders form for editing chosen metadata", %{conn: conn, metadata: metadata} do
      conn = get conn, metadata_path(conn, :edit, metadata)
      assert html_response(conn, 200) =~ "Edit Metadata"
    end
  end

  describe "update metadata" do
    setup [:create_metadata]

    test "redirects when data is valid", %{conn: conn, metadata: metadata} do
      conn = put conn, metadata_path(conn, :update, metadata), metadata: @update_attrs
      assert redirected_to(conn) == metadata_path(conn, :show, metadata)

      conn = get conn, metadata_path(conn, :show, metadata)
      assert html_response(conn, 200) =~ "some updated group"
    end

    test "renders errors when data is invalid", %{conn: conn, metadata: metadata} do
      conn = put conn, metadata_path(conn, :update, metadata), metadata: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Metadata"
    end
  end

  describe "delete metadata" do
    setup [:create_metadata]

    test "deletes chosen metadata", %{conn: conn, metadata: metadata} do
      conn = delete conn, metadata_path(conn, :delete, metadata)
      assert redirected_to(conn) == metadata_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, metadata_path(conn, :show, metadata)
      end
    end
  end

  defp create_metadata(_) do
    metadata = fixture(:metadata)
    {:ok, metadata: metadata}
  end
end
