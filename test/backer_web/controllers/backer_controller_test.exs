defmodule BackerWeb.BackerControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Account

  @create_attrs %{
    avatar: "some avatar",
    backer_bio: "some backer_bio",
    birth_date: ~D[2010-04-17],
    display_name: "some display_name",
    email: "some email",
    email_verification_code: "some email_verification_code",
    full_name: "some full_name",
    id_number: "some id_number",
    id_photo: "some id_photo",
    id_photokyc: "some id_photokyc",
    id_type: "some id_type",
    is_email_verified: true,
    is_phone_verified: true,
    is_pledger: true,
    password_recovery_code: "some password_recovery_code",
    passwordhash: "some passwordhash",
    phone: "some phone",
    phone_verification_code: "some phone_verification_code",
    recover_phone: "some recover_phone",
    username: "some username"
  }
  @update_attrs %{
    avatar: "some updated avatar",
    backer_bio: "some updated backer_bio",
    birth_date: ~D[2011-05-18],
    display_name: "some updated display_name",
    email: "some updated email",
    email_verification_code: "some updated email_verification_code",
    full_name: "some updated full_name",
    id_number: "some updated id_number",
    id_photo: "some updated id_photo",
    id_photokyc: "some updated id_photokyc",
    id_type: "some updated id_type",
    is_email_verified: false,
    is_phone_verified: false,
    is_pledger: false,
    password_recovery_code: "some updated password_recovery_code",
    passwordhash: "some updated passwordhash",
    phone: "some updated phone",
    phone_verification_code: "some updated phone_verification_code",
    recover_phone: "some updated recover_phone",
    username: "some updated username"
  }
  @invalid_attrs %{
    avatar: nil,
    backer_bio: nil,
    birth_date: nil,
    display_name: nil,
    email: nil,
    email_verification_code: nil,
    full_name: nil,
    id_number: nil,
    id_photo: nil,
    id_photokyc: nil,
    id_type: nil,
    is_email_verified: nil,
    is_phone_verified: nil,
    is_pledger: nil,
    password_recovery_code: nil,
    passwordhash: nil,
    phone: nil,
    phone_verification_code: nil,
    recover_phone: nil,
    username: nil
  }

  def fixture(:backer) do
    {:ok, backer} = Account.create_backer(@create_attrs)
    backer
  end

  describe "index" do
    test "lists all backers", %{conn: conn} do
      conn = get(conn, backer_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Backers"
    end
  end

  describe "new backer" do
    test "renders form", %{conn: conn} do
      conn = get(conn, backer_path(conn, :new))
      assert html_response(conn, 200) =~ "New Backer"
    end
  end

  describe "create backer" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, backer_path(conn, :create), backer: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == backer_path(conn, :show, id)

      conn = get(conn, backer_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Backer"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, backer_path(conn, :create), backer: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Backer"
    end
  end

  describe "edit backer" do
    setup [:create_backer]

    test "renders form for editing chosen backer", %{conn: conn, backer: backer} do
      conn = get(conn, backer_path(conn, :edit, backer))
      assert html_response(conn, 200) =~ "Edit Backer"
    end
  end

  describe "update backer" do
    setup [:create_backer]

    test "redirects when data is valid", %{conn: conn, backer: backer} do
      conn = put(conn, backer_path(conn, :update, backer), backer: @update_attrs)
      assert redirected_to(conn) == backer_path(conn, :show, backer)

      conn = get(conn, backer_path(conn, :show, backer))
      assert html_response(conn, 200) =~ "some updated avatar"
    end

    test "renders errors when data is invalid", %{conn: conn, backer: backer} do
      conn = put(conn, backer_path(conn, :update, backer), backer: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Backer"
    end
  end

  describe "delete backer" do
    setup [:create_backer]

    test "deletes chosen backer", %{conn: conn, backer: backer} do
      conn = delete(conn, backer_path(conn, :delete, backer))
      assert redirected_to(conn) == backer_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, backer_path(conn, :show, backer))
      end)
    end
  end

  defp create_backer(_) do
    backer = fixture(:backer)
    {:ok, backer: backer}
  end
end
