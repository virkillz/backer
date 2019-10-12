defmodule SendMail do
  alias SendGrid.Email

  def verification(email, display_name, verification_code) do
    Email.build()
    |> Email.add_to(email)
    |> Email.put_from("noreply@backer.id")
    |> Email.put_subject("[Backer.id] Verifikasi email kamu")
    |> Email.put_phoenix_view(BackerWeb.PublicView)
    |> Email.put_phoenix_template("email_verify.html",
      display_name: display_name,
      verification_code: verification_code,
      domain: get_domain
    )
    |> SendGrid.Mail.send()
  end

  def send_reset_password(email, display_name, reset_password_code) do
    Email.build()
    |> Email.add_to(email)
    |> Email.put_from("noreply@backer.id")
    |> Email.put_subject("[Backer.id] Reset password akun kamu.")
    |> Email.put_phoenix_view(BackerWeb.EmailView)
    |> Email.put_phoenix_template("send_reset_password_link.html",
      display_name: display_name,
      reset_password_code: reset_password_code,
      domain: get_domain()
    )
    |> SendGrid.Mail.send()
  end

  def get_domain() do
    case Application.get_env(:backer, :env) do
      nil -> "http://localhost:4000"
      :dev -> "http://localhost:4000"
      :uat -> "http://alpha.backer.id"
      :prod -> "http://alpha.backer.id"
    end
  end
end
