defmodule BackerWeb.SubmissionControllerTest do
  use BackerWeb.ConnCase

  alias Backer.Temporary

  @create_attrs %{acceptance_status: "some acceptance_status", applicant_email: "some applicant_email", applicant_name: "some applicant_name", applicant_phone: "some applicant_phone", comment: "some comment", donee_description: "some donee_description", donee_name: "some donee_name", donee_website: "some donee_website", email_preffered: true, handle_status: "some handle_status", phone_preffered: true, whatsapp_preffered: true}
  @update_attrs %{acceptance_status: "some updated acceptance_status", applicant_email: "some updated applicant_email", applicant_name: "some updated applicant_name", applicant_phone: "some updated applicant_phone", comment: "some updated comment", donee_description: "some updated donee_description", donee_name: "some updated donee_name", donee_website: "some updated donee_website", email_preffered: false, handle_status: "some updated handle_status", phone_preffered: false, whatsapp_preffered: false}
  @invalid_attrs %{acceptance_status: nil, applicant_email: nil, applicant_name: nil, applicant_phone: nil, comment: nil, donee_description: nil, donee_name: nil, donee_website: nil, email_preffered: nil, handle_status: nil, phone_preffered: nil, whatsapp_preffered: nil}

  def fixture(:submission) do
    {:ok, submission} = Temporary.create_submission(@create_attrs)
    submission
  end

  describe "index" do
    test "lists all submissions", %{conn: conn} do
      conn = get conn, submission_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Submissions"
    end
  end

  describe "new submission" do
    test "renders form", %{conn: conn} do
      conn = get conn, submission_path(conn, :new)
      assert html_response(conn, 200) =~ "New Submission"
    end
  end

  describe "create submission" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, submission_path(conn, :create), submission: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == submission_path(conn, :show, id)

      conn = get conn, submission_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Submission"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, submission_path(conn, :create), submission: @invalid_attrs
      assert html_response(conn, 200) =~ "New Submission"
    end
  end

  describe "edit submission" do
    setup [:create_submission]

    test "renders form for editing chosen submission", %{conn: conn, submission: submission} do
      conn = get conn, submission_path(conn, :edit, submission)
      assert html_response(conn, 200) =~ "Edit Submission"
    end
  end

  describe "update submission" do
    setup [:create_submission]

    test "redirects when data is valid", %{conn: conn, submission: submission} do
      conn = put conn, submission_path(conn, :update, submission), submission: @update_attrs
      assert redirected_to(conn) == submission_path(conn, :show, submission)

      conn = get conn, submission_path(conn, :show, submission)
      assert html_response(conn, 200) =~ "some updated acceptance_status"
    end

    test "renders errors when data is invalid", %{conn: conn, submission: submission} do
      conn = put conn, submission_path(conn, :update, submission), submission: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Submission"
    end
  end

  describe "delete submission" do
    setup [:create_submission]

    test "deletes chosen submission", %{conn: conn, submission: submission} do
      conn = delete conn, submission_path(conn, :delete, submission)
      assert redirected_to(conn) == submission_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, submission_path(conn, :show, submission)
      end
    end
  end

  defp create_submission(_) do
    submission = fixture(:submission)
    {:ok, submission: submission}
  end
end
