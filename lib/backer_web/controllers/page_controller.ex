defmodule BackerWeb.PageController do
  use BackerWeb, :controller

  alias Backer.Account
  alias Backer.Account.User
  alias Backer.Account.Backer, as: Backerz

  def index(conn, _params) do
    changeset = Account.change_backer(%Backerz{})

    conn
    |> render("homepage.html",
      changeset: changeset,
      layout: {BackerWeb.LayoutView, "homepage_frontend_layout.html"}
    )
  end

  def static_page(conn, %{"slug" => slug}) do
    case slug do
      "how-it-works" ->
        render(conn, "static_how_it_works.html",
          layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
        )

      _else ->
        conn
        |> put_status(:not_found)
        |> render("404.html",
          layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
        )
    end
  end

  def verify(conn, %{"code" => code}) do
    case Account.backer_verification_valid(code) do
      {:not_yet, backer} ->
        Account.validate_backer(backer)

        render(conn, "verify.html",
          status: :not_yet,
          layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
        )

      {:error, _} ->
        render(conn, "verify.html",
          status: :error,
          layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
        )

      {:already, _} ->
        render(conn, "verify.html",
          status: :already,
          layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
        )
    end
  end

  def verify(conn, _params) do
    redirect(conn, to: "/404")
  end

  def resend(conn, %{"email" => email}) do
    payload =
      case Account.get_backer(%{"email" => email}) do
        nil ->
          %{
            title: "Email cannot be sent",
            message: "Either we don't recognize this email or it has been verified."
          }

        backer ->
          payload =
            if backer.is_email_verified do
              %{
                title: "Email cannot be sent",
                message: "Either we don't recognize this email or it has been verified."
              }
            else
              # SENT THE ACTUAL FRIGGNI EMAIL HERE
              %{
                title: "Email sent!",
                message:
                  "Please check your email, we already re-sent your email verification instruction."
              }
            end
      end

    render(conn, "generic.html",
      payload: payload,
      layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
    )
  end

  def resend(conn, _params) do
    redirect(conn, to: "/404")
  end

  # if no parameter
  def static_page(conn, params) do
    redirect(conn, to: "/404")
  end

  def page404(conn, _params) do
    conn
    |> put_status(:not_found)
    |> render("404.html", layout: {BackerWeb.LayoutView, "frontend_header_footer.html"})
  end

  def page505(conn, _params) do
    text(conn, "505 bro")
    # conn
    # |> put_status(:not_found)
    # |> render("404.html", layout: {BackerWeb.LayoutView, "frontend_header_footer.html"})
  end

  def login(conn, _params) do
    changeset = Account.change_backer(%Backerz{})

    render(conn, "login_register.html",
      layout: {BackerWeb.LayoutView, "header_only.html"},
      changeset: changeset,
      action: :login
    )
  end

  def register(conn, params) do
    changeset = Account.change_backer(%Backerz{})

    render(conn, "login_register.html",
      layout: {BackerWeb.LayoutView, "header_only.html"},
      changeset: changeset,
      action: :register
    )
  end

  def createuser(conn, %{"backer" => params}) do
    case Account.register_backer(params) do
      {:ok, _user} ->
        conn
        |> put_flash(
          :info,
          "User created successfully. Please check your email and verify before login"
        )
        |> redirect(to: "/login")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        # |> put_flash(:error, "Oops, check error below")
        |> render("login_register.html",
          layout: {BackerWeb.LayoutView, "header_only.html"},
          changeset: changeset,
          action: :register
        )
    end
  end

  def auth(conn, %{"email" => email, "password" => password}) do
    case Account.authenticate_backer_front(email, password) do
      {:ok, backer} ->
        if backer.is_email_verified do
          conn
          |> put_session(:current_user_id, backer.id)
          |> redirect(to: "/backer/" <> backer.username)
        else
          render(conn, "please_verify_first.html",
            layout: {BackerWeb.LayoutView, "frontend_header_footer.html"},
            backer: backer
          )
        end

      {:error, reason} ->
        changeset = Account.change_backer(%Backerz{})

        conn
        |> put_flash(:error, reason)
        |> render("login_register.html",
          layout: {BackerWeb.LayoutView, "header_only.html"},
          changeset: changeset,
          action: :login
        )
    end
  end

  def forgot_password(conn, _params) do
    render(conn, "recover.html", layout: {BackerWeb.LayoutView, "frontend_header_footer.html"})
  end

  def forgot_password_post(conn, %{"email" => email}) do
    # if user founded, generate new recovery key
    backer = Account.get_backer(%{"email" => email})

    if backer != nil do
      params = %{"password_recovery_code" => Ecto.UUID.generate()}
      Account.update_backer(backer, params)
    end

    payload = %{
      title: "Done!",
      message:
        "If we found your email in our database, we will sent the password recodery link. Please check your email."
    }

    render(conn, "generic.html",
      payload: payload,
      layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
    )
  end

  def change_password(conn, %{"code" => code}) do
    backer = Account.get_backer(%{"password_recovery_code" => code})
    changeset = Account.change_password_backer(%Backerz{}) |> IO.inspect()

    if backer == nil do
      payload = %{
        title: "Invalid",
        message:
          "The link is invalid. Please use again recover-password menu to generate and resend the code to your email."
      }

      render(conn, "generic.html",
        payload: payload,
        layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
      )
    else
      render(conn, "change-password.html",
        code: code,
        changeset: changeset,
        layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
      )
    end
  end

  def change_password(conn, _params) do
    redirect(conn, to: "/404")
  end

  def change_password_post(conn, %{"backer" => params}) do
    IO.inspect(params)
    backer = Account.get_backer(%{"password_recovery_code" => params["code"]})

    if backer == nil do
      # GIVE SCARY FORBIDDEN PAGE HERE
      text(conn, "503. forbidden. please don't do that :(")
    else
      case Account.update_password_backer(backer, params) do
        {:ok, _user} ->
          conn
          |> put_flash(
            :info,
            "Password updated successfully. Now you can login."
          )
          |> redirect(to: "/login")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "change-password.html",
            code: params["code"],
            changeset: changeset,
            layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
          )
      end
    end
  end

  def signout(conn, _parms) do
    conn
    |> Plug.Conn.configure_session(drop: true)
    |> redirect(to: "/")
  end

  def current_user(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id, do: Repo.get(User, user_id)
  end

  def user_signed_in?(conn) do
    !!current_user(conn)
  end
end
