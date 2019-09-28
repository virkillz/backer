defmodule Backer.TemporaryTest do
  use Backer.DataCase

  alias Backer.Temporary

  describe "submissions" do
    alias Backer.Temporary.Submission

    @valid_attrs %{acceptance_status: "some acceptance_status", applicant_email: "some applicant_email", applicant_name: "some applicant_name", applicant_phone: "some applicant_phone", comment: "some comment", donee_description: "some donee_description", donee_name: "some donee_name", donee_website: "some donee_website", email_preffered: true, handle_status: "some handle_status", phone_preffered: true, whatsapp_preffered: true}
    @update_attrs %{acceptance_status: "some updated acceptance_status", applicant_email: "some updated applicant_email", applicant_name: "some updated applicant_name", applicant_phone: "some updated applicant_phone", comment: "some updated comment", donee_description: "some updated donee_description", donee_name: "some updated donee_name", donee_website: "some updated donee_website", email_preffered: false, handle_status: "some updated handle_status", phone_preffered: false, whatsapp_preffered: false}
    @invalid_attrs %{acceptance_status: nil, applicant_email: nil, applicant_name: nil, applicant_phone: nil, comment: nil, donee_description: nil, donee_name: nil, donee_website: nil, email_preffered: nil, handle_status: nil, phone_preffered: nil, whatsapp_preffered: nil}

    def submission_fixture(attrs \\ %{}) do
      {:ok, submission} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Temporary.create_submission()

      submission
    end

    test "list_submissions/0 returns all submissions" do
      submission = submission_fixture()
      assert Temporary.list_submissions() == [submission]
    end

    test "get_submission!/1 returns the submission with given id" do
      submission = submission_fixture()
      assert Temporary.get_submission!(submission.id) == submission
    end

    test "create_submission/1 with valid data creates a submission" do
      assert {:ok, %Submission{} = submission} = Temporary.create_submission(@valid_attrs)
      assert submission.acceptance_status == "some acceptance_status"
      assert submission.applicant_email == "some applicant_email"
      assert submission.applicant_name == "some applicant_name"
      assert submission.applicant_phone == "some applicant_phone"
      assert submission.comment == "some comment"
      assert submission.donee_description == "some donee_description"
      assert submission.donee_name == "some donee_name"
      assert submission.donee_website == "some donee_website"
      assert submission.email_preffered == true
      assert submission.handle_status == "some handle_status"
      assert submission.phone_preffered == true
      assert submission.whatsapp_preffered == true
    end

    test "create_submission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Temporary.create_submission(@invalid_attrs)
    end

    test "update_submission/2 with valid data updates the submission" do
      submission = submission_fixture()
      assert {:ok, %Submission{} = submission} = Temporary.update_submission(submission, @update_attrs)
      assert submission.acceptance_status == "some updated acceptance_status"
      assert submission.applicant_email == "some updated applicant_email"
      assert submission.applicant_name == "some updated applicant_name"
      assert submission.applicant_phone == "some updated applicant_phone"
      assert submission.comment == "some updated comment"
      assert submission.donee_description == "some updated donee_description"
      assert submission.donee_name == "some updated donee_name"
      assert submission.donee_website == "some updated donee_website"
      assert submission.email_preffered == false
      assert submission.handle_status == "some updated handle_status"
      assert submission.phone_preffered == false
      assert submission.whatsapp_preffered == false
    end

    test "update_submission/2 with invalid data returns error changeset" do
      submission = submission_fixture()
      assert {:error, %Ecto.Changeset{}} = Temporary.update_submission(submission, @invalid_attrs)
      assert submission == Temporary.get_submission!(submission.id)
    end

    test "delete_submission/1 deletes the submission" do
      submission = submission_fixture()
      assert {:ok, %Submission{}} = Temporary.delete_submission(submission)
      assert_raise Ecto.NoResultsError, fn -> Temporary.get_submission!(submission.id) end
    end

    test "change_submission/1 returns a submission changeset" do
      submission = submission_fixture()
      assert %Ecto.Changeset{} = Temporary.change_submission(submission)
    end
  end

  describe "contacts" do
    alias Backer.Temporary.Contact

    @valid_attrs %{email: "some email", is_read: true, message: "some message", name: "some name", phone: "some phone", remark: "some remark", status: "some status", title: "some title"}
    @update_attrs %{email: "some updated email", is_read: false, message: "some updated message", name: "some updated name", phone: "some updated phone", remark: "some updated remark", status: "some updated status", title: "some updated title"}
    @invalid_attrs %{email: nil, is_read: nil, message: nil, name: nil, phone: nil, remark: nil, status: nil, title: nil}

    def contact_fixture(attrs \\ %{}) do
      {:ok, contact} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Temporary.create_contact()

      contact
    end

    test "list_contacts/0 returns all contacts" do
      contact = contact_fixture()
      assert Temporary.list_contacts() == [contact]
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = contact_fixture()
      assert Temporary.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      assert {:ok, %Contact{} = contact} = Temporary.create_contact(@valid_attrs)
      assert contact.email == "some email"
      assert contact.is_read == true
      assert contact.message == "some message"
      assert contact.name == "some name"
      assert contact.phone == "some phone"
      assert contact.remark == "some remark"
      assert contact.status == "some status"
      assert contact.title == "some title"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Temporary.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{} = contact} = Temporary.update_contact(contact, @update_attrs)
      assert contact.email == "some updated email"
      assert contact.is_read == false
      assert contact.message == "some updated message"
      assert contact.name == "some updated name"
      assert contact.phone == "some updated phone"
      assert contact.remark == "some updated remark"
      assert contact.status == "some updated status"
      assert contact.title == "some updated title"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = contact_fixture()
      assert {:error, %Ecto.Changeset{}} = Temporary.update_contact(contact, @invalid_attrs)
      assert contact == Temporary.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{}} = Temporary.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Temporary.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()
      assert %Ecto.Changeset{} = Temporary.change_contact(contact)
    end
  end
end
