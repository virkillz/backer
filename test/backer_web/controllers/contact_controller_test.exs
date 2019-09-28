defmodule BackerWeb.ContactControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Temporary

  @create_attrs %{email: "some email", is_read: true, message: "some message", name: "some name", phone: "some phone", remark: "some remark", status: "some status", title: "some title"}
  @update_attrs %{email: "some updated email", is_read: false, message: "some updated message", name: "some updated name", phone: "some updated phone", remark: "some updated remark", status: "some updated status", title: "some updated title"}
  @invalid_attrs %{email: nil, is_read: nil, message: nil, name: nil, phone: nil, remark: nil, status: nil, title: nil}

  def fixture(:contact) do
    {:ok, contact} = Temporary.create_contact(@create_attrs)
    contact
  end

  describe "index" do
    test "lists all contacts", %{conn: conn} do
      conn = get conn, contact_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Contacts"
    end
  end

  describe "new contact" do
    test "renders form", %{conn: conn} do
      conn = get conn, contact_path(conn, :new)
      assert html_response(conn, 200) =~ "New Contact"
    end
  end

  describe "create contact" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, contact_path(conn, :create), contact: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == contact_path(conn, :show, id)

      conn = get conn, contact_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Contact"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, contact_path(conn, :create), contact: @invalid_attrs
      assert html_response(conn, 200) =~ "New Contact"
    end
  end

  describe "edit contact" do
    setup [:create_contact]

    test "renders form for editing chosen contact", %{conn: conn, contact: contact} do
      conn = get conn, contact_path(conn, :edit, contact)
      assert html_response(conn, 200) =~ "Edit Contact"
    end
  end

  describe "update contact" do
    setup [:create_contact]

    test "redirects when data is valid", %{conn: conn, contact: contact} do
      conn = put conn, contact_path(conn, :update, contact), contact: @update_attrs
      assert redirected_to(conn) == contact_path(conn, :show, contact)

      conn = get conn, contact_path(conn, :show, contact)
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, contact: contact} do
      conn = put conn, contact_path(conn, :update, contact), contact: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Contact"
    end
  end

  describe "delete contact" do
    setup [:create_contact]

    test "deletes chosen contact", %{conn: conn, contact: contact} do
      conn = delete conn, contact_path(conn, :delete, contact)
      assert redirected_to(conn) == contact_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, contact_path(conn, :show, contact)
      end
    end
  end

  defp create_contact(_) do
    contact = fixture(:contact)
    {:ok, contact: contact}
  end
end
