defmodule Backer.ContentTest do
  use Backer.DataCase

  alias Backer.Content

  describe "notifications" do
    alias Backer.Content.Notification

    @valid_attrs %{additional_note: "some additional_note", content: "some content", is_read: true, other_ref_id: 42, type: "some type"}
    @update_attrs %{additional_note: "some updated additional_note", content: "some updated content", is_read: false, other_ref_id: 43, type: "some updated type"}
    @invalid_attrs %{additional_note: nil, content: nil, is_read: nil, other_ref_id: nil, type: nil}

    def notification_fixture(attrs \\ %{}) do
      {:ok, notification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_notification()

      notification
    end

    test "list_notifications/0 returns all notifications" do
      notification = notification_fixture()
      assert Content.list_notifications() == [notification]
    end

    test "get_notification!/1 returns the notification with given id" do
      notification = notification_fixture()
      assert Content.get_notification!(notification.id) == notification
    end

    test "create_notification/1 with valid data creates a notification" do
      assert {:ok, %Notification{} = notification} = Content.create_notification(@valid_attrs)
      assert notification.additional_note == "some additional_note"
      assert notification.content == "some content"
      assert notification.is_read == true
      assert notification.other_ref_id == 42
      assert notification.type == "some type"
    end

    test "create_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_notification(@invalid_attrs)
    end

    test "update_notification/2 with valid data updates the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{} = notification} = Content.update_notification(notification, @update_attrs)
      assert notification.additional_note == "some updated additional_note"
      assert notification.content == "some updated content"
      assert notification.is_read == false
      assert notification.other_ref_id == 43
      assert notification.type == "some updated type"
    end

    test "update_notification/2 with invalid data returns error changeset" do
      notification = notification_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_notification(notification, @invalid_attrs)
      assert notification == Content.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{}} = Content.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> Content.get_notification!(notification.id) end
    end

    test "change_notification/1 returns a notification changeset" do
      notification = notification_fixture()
      assert %Ecto.Changeset{} = Content.change_notification(notification)
    end
  end
end
