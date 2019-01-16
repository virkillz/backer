defmodule Backer.AccountTest do
  use Backer.DataCase

  alias Backer.Account

  describe "backers" do
    alias Backer.Account.Backer

    @valid_attrs %{
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

    def backer_fixture(attrs \\ %{}) do
      {:ok, backer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_backer()

      backer
    end

    test "list_backers/0 returns all backers" do
      backer = backer_fixture()
      assert Account.list_backers() == [backer]
    end

    test "get_backer!/1 returns the backer with given id" do
      backer = backer_fixture()
      assert Account.get_backer!(backer.id) == backer
    end

    test "create_backer/1 with valid data creates a backer" do
      assert {:ok, %Backer{} = backer} = Account.create_backer(@valid_attrs)
      assert backer.avatar == "some avatar"
      assert backer.backer_bio == "some backer_bio"
      assert backer.birth_date == ~D[2010-04-17]
      assert backer.display_name == "some display_name"
      assert backer.email == "some email"
      assert backer.email_verification_code == "some email_verification_code"
      assert backer.full_name == "some full_name"
      assert backer.id_number == "some id_number"
      assert backer.id_photo == "some id_photo"
      assert backer.id_photokyc == "some id_photokyc"
      assert backer.id_type == "some id_type"
      assert backer.is_email_verified == true
      assert backer.is_phone_verified == true
      assert backer.is_pledger == true
      assert backer.password_recovery_code == "some password_recovery_code"
      assert backer.passwordhash == "some passwordhash"
      assert backer.phone == "some phone"
      assert backer.phone_verification_code == "some phone_verification_code"
      assert backer.recover_phone == "some recover_phone"
      assert backer.username == "some username"
    end

    test "create_backer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_backer(@invalid_attrs)
    end

    test "update_backer/2 with valid data updates the backer" do
      backer = backer_fixture()
      assert {:ok, backer} = Account.update_backer(backer, @update_attrs)
      assert %Backer{} = backer
      assert backer.avatar == "some updated avatar"
      assert backer.backer_bio == "some updated backer_bio"
      assert backer.birth_date == ~D[2011-05-18]
      assert backer.display_name == "some updated display_name"
      assert backer.email == "some updated email"
      assert backer.email_verification_code == "some updated email_verification_code"
      assert backer.full_name == "some updated full_name"
      assert backer.id_number == "some updated id_number"
      assert backer.id_photo == "some updated id_photo"
      assert backer.id_photokyc == "some updated id_photokyc"
      assert backer.id_type == "some updated id_type"
      assert backer.is_email_verified == false
      assert backer.is_phone_verified == false
      assert backer.is_pledger == false
      assert backer.password_recovery_code == "some updated password_recovery_code"
      assert backer.passwordhash == "some updated passwordhash"
      assert backer.phone == "some updated phone"
      assert backer.phone_verification_code == "some updated phone_verification_code"
      assert backer.recover_phone == "some updated recover_phone"
      assert backer.username == "some updated username"
    end

    test "update_backer/2 with invalid data returns error changeset" do
      backer = backer_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_backer(backer, @invalid_attrs)
      assert backer == Account.get_backer!(backer.id)
    end

    test "delete_backer/1 deletes the backer" do
      backer = backer_fixture()
      assert {:ok, %Backer{}} = Account.delete_backer(backer)
      assert_raise Ecto.NoResultsError, fn -> Account.get_backer!(backer.id) end
    end

    test "change_backer/1 returns a backer changeset" do
      backer = backer_fixture()
      assert %Ecto.Changeset{} = Account.change_backer(backer)
    end
  end

  describe "pledgers" do
    alias Backer.Account.Pledger

    @valid_attrs %{
      account_id: "some account_id",
      account_name: "some account_name",
      background: "some background",
      bank_book_picture: "some bank_book_picture",
      bank_name: "some bank_name",
      pledger_overview: "some pledger_overview",
      status: "some status"
    }
    @update_attrs %{
      account_id: "some updated account_id",
      account_name: "some updated account_name",
      background: "some updated background",
      bank_book_picture: "some updated bank_book_picture",
      bank_name: "some updated bank_name",
      pledger_overview: "some updated pledger_overview",
      status: "some updated status"
    }
    @invalid_attrs %{
      account_id: nil,
      account_name: nil,
      background: nil,
      bank_book_picture: nil,
      bank_name: nil,
      pledger_overview: nil,
      status: nil
    }

    def pledger_fixture(attrs \\ %{}) do
      {:ok, pledger} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_pledger()

      pledger
    end

    test "list_pledgers/0 returns all pledgers" do
      pledger = pledger_fixture()
      assert Account.list_pledgers() == [pledger]
    end

    test "get_pledger!/1 returns the pledger with given id" do
      pledger = pledger_fixture()
      assert Account.get_pledger!(pledger.id) == pledger
    end

    test "create_pledger/1 with valid data creates a pledger" do
      assert {:ok, %Pledger{} = pledger} = Account.create_pledger(@valid_attrs)
      assert pledger.account_id == "some account_id"
      assert pledger.account_name == "some account_name"
      assert pledger.background == "some background"
      assert pledger.bank_book_picture == "some bank_book_picture"
      assert pledger.bank_name == "some bank_name"
      assert pledger.pledger_overview == "some pledger_overview"
      assert pledger.status == "some status"
    end

    test "create_pledger/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_pledger(@invalid_attrs)
    end

    test "update_pledger/2 with valid data updates the pledger" do
      pledger = pledger_fixture()
      assert {:ok, pledger} = Account.update_pledger(pledger, @update_attrs)
      assert %Pledger{} = pledger
      assert pledger.account_id == "some updated account_id"
      assert pledger.account_name == "some updated account_name"
      assert pledger.background == "some updated background"
      assert pledger.bank_book_picture == "some updated bank_book_picture"
      assert pledger.bank_name == "some updated bank_name"
      assert pledger.pledger_overview == "some updated pledger_overview"
      assert pledger.status == "some updated status"
    end

    test "update_pledger/2 with invalid data returns error changeset" do
      pledger = pledger_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_pledger(pledger, @invalid_attrs)
      assert pledger == Account.get_pledger!(pledger.id)
    end

    test "delete_pledger/1 deletes the pledger" do
      pledger = pledger_fixture()
      assert {:ok, %Pledger{}} = Account.delete_pledger(pledger)
      assert_raise Ecto.NoResultsError, fn -> Account.get_pledger!(pledger.id) end
    end

    test "change_pledger/1 returns a pledger changeset" do
      pledger = pledger_fixture()
      assert %Ecto.Changeset{} = Account.change_pledger(pledger)
    end
  end
end
