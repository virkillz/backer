defmodule BackerWeb.SubmissionController do
  use BackerWeb, :controller

  alias Backer.Temporary
  alias Backer.Temporary.Submission

  def index(conn, _params) do
    submissions = Temporary.list_submissions()
    render(conn, "index.html", submissions: submissions)
  end

  def new(conn, _params) do
    changeset = Temporary.change_submission(%Submission{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"submission" => submission_params}) do
    case Temporary.create_submission(submission_params) do
      {:ok, submission} ->
        conn
        |> put_flash(:info, "Submission created successfully.")
        |> redirect(to: Router.submission_path(conn, :show, submission))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    submission = Temporary.get_submission!(id)
    render(conn, "show.html", submission: submission)
  end

  def edit(conn, %{"id" => id}) do
    submission = Temporary.get_submission!(id)
    changeset = Temporary.change_submission(submission)
    render(conn, "edit.html", submission: submission, changeset: changeset)
  end

  def update(conn, %{"id" => id, "submission" => submission_params}) do
    submission = Temporary.get_submission!(id)

    case Temporary.update_submission(submission, submission_params) do
      {:ok, submission} ->
        conn
        |> put_flash(:info, "Submission updated successfully.")
        |> redirect(to: Router.submission_path(conn, :show, submission))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", submission: submission, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    submission = Temporary.get_submission!(id)
    {:ok, _submission} = Temporary.delete_submission(submission)

    conn
    |> put_flash(:info, "Submission deleted successfully.")
    |> redirect(to: Router.submission_path(conn, :index))
  end
end
