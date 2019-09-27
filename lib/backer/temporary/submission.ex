defmodule Backer.Temporary.Submission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "submissions" do
    field(:acceptance_status, :string, default: "undecided")
    field(:applicant_email, :string)
    field(:applicant_name, :string)
    field(:applicant_phone, :string)
    field(:comment, :string)
    field(:donee_description, :string)
    field(:donee_name, :string)
    field(:donee_website, :string)
    field(:email_preffered, :boolean, default: false)
    field(:handle_status, :string, default: "unhandled")
    field(:phone_preffered, :boolean, default: false)
    field(:whatsapp_preffered, :boolean, default: false)

    timestamps()
  end

  @doc false
  def changeset(submission, attrs) do
    submission
    |> cast(attrs, [
      :donee_name,
      :donee_website,
      :donee_description,
      :applicant_name,
      :applicant_email,
      :applicant_phone,
      :phone_preffered,
      :email_preffered,
      :whatsapp_preffered,
      :handle_status,
      :comment,
      :acceptance_status
    ])
    |> validate_required([
      :donee_name,
      :donee_website,
      :donee_description,
      :applicant_name,
      :applicant_email,
      :applicant_phone,
      :phone_preffered,
      :email_preffered,
      :whatsapp_preffered
    ])
  end
end
