defmodule BackerWeb.NotificationControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Content

  @create_attrs %{additional_note: "some additional_note", content: "some content", is_read: true, other_ref_id: 42, type: "some type"}
  @update_attrs %{additional_note: "some updated additional_note", content: "some updated content", is_read: false, other_ref_id: 43, type: "some updated type"}
  @invalid_attrs %{additional_note: nil, content: nil, is_read: nil, other_ref_id: nil, type: nil}

  def fixture(:notification) do
    {:ok, notification} = Content.create_notification(@create_attrs)
    notification
  end

  describe "index" do
    test "lists all notifications", %{conn: conn} do
      conn = get conn, notification_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Notifications"
    end
  end

  describe "new notification" do
    test "renders form", %{conn: conn} do
      conn = get conn, notification_path(conn, :new)
      assert html_response(conn, 200) =~ "New Notification"
    end
  end

  describe "create notification" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, notification_path(conn, :create), notification: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == notification_path(conn, :show, id)

      conn = get conn, notification_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Notification"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, notification_path(conn, :create), notification: @invalid_attrs
      assert html_response(conn, 200) =~ "New Notification"
    end
  end

  describe "edit notification" do
    setup [:create_notification]

    test "renders form for editing chosen notification", %{conn: conn, notification: notification} do
      conn = get conn, notification_path(conn, :edit, notification)
      assert html_response(conn, 200) =~ "Edit Notification"
    end
  end

  describe "update notification" do
    setup [:create_notification]

    test "redirects when data is valid", %{conn: conn, notification: notification} do
      conn = put conn, notification_path(conn, :update, notification), notification: @update_attrs
      assert redirected_to(conn) == notification_path(conn, :show, notification)

      conn = get conn, notification_path(conn, :show, notification)
      assert html_response(conn, 200) =~ "some updated additional_note"
    end

    test "renders errors when data is invalid", %{conn: conn, notification: notification} do
      conn = put conn, notification_path(conn, :update, notification), notification: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Notification"
    end
  end

  describe "delete notification" do
    setup [:create_notification]

    test "deletes chosen notification", %{conn: conn, notification: notification} do
      conn = delete conn, notification_path(conn, :delete, notification)
      assert redirected_to(conn) == notification_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, notification_path(conn, :show, notification)
      end
    end
  end

  defp create_notification(_) do
    notification = fixture(:notification)
    {:ok, notification: notification}
  end
end
