defmodule SendMail do
  alias SendGrid.Email

  def verification(email, display_name, verification_code) do
    domain =
      case Application.get_env(:backer, :env) do
        nil -> "http://localhost:4000"
        :dev -> "http://alpha.backer.id"
        :uat -> "http://alpha.backer.id"
        :prod -> "http://alpha.backer.id"
      end

    Email.build()
    |> Email.add_to(email)
    |> Email.put_from("noreply@backer.id")
    |> Email.put_subject("[Backer.id] Verifikasi email kamu")
    |> Email.put_phoenix_view(BackerWeb.PublicView)
    |> Email.put_phoenix_template("email_verify.html",
      display_name: display_name,
      verification_code: verification_code,
      domain: domain
    )
    |> SendGrid.Mail.send()
  end
end
