defmodule BackerWeb.EmailController do
  use BackerWeb, :controller

  def send_email_verification(conn, params) do
    conn
    |> put_layout(false)
    |> render("send_email_verification.html",
      display_name: "VirKill",
      domain: "http://localhost:4000",
      verification_code: "asdasd"
    )
  end

  def send_reset_password_link(conn, params) do
    conn
    |> put_layout(false)
    |> render("send_reset_password_link.html",
      display_name: "VirKill",
      domain: "http://localhost:4000",
      reset_password_code: "asdasd"
    )
  end
end
