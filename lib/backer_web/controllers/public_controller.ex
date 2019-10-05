defmodule BackerWeb.PublicController do
  use BackerWeb, :controller

  alias Backer.Account
  alias Backer.Account.User
  alias Backer.Account.Backer, as: Backerz
  alias Backer.Temporary.Submission
  alias Backer.Temporary
  alias Backer.Temporary.Contact

  def index(conn, _params) do
    meta = %{title: "Welcome to backer"}

    meta_attrs = [
      %{name: "keywords", content: "........"},
      %{name: "description", content: "........."},
      %{property: "og:image", content: "......"}
    ]

    random_donee = Account.get_random_donee(6)
    highlight_donee = Account.get_highlight_donee_homepage() |> IO.inspect()

    conn
    |> render("homepage.html",
      layout: {BackerWeb.LayoutView, "public.html"},
      meta: meta,
      meta_attrs: meta_attrs,
      highlight_donee: highlight_donee,
      random_donee: random_donee
    )
  end

  def explore(conn, _params) do
    meta = %{title: "Welcome to backer"}

    donees = Account.list_donees()

    conn
    |> render("explore.html",
      layout: {BackerWeb.LayoutView, "public.html"},
      meta: meta,
      donees: donees
    )
  end

  def forgot_password(conn, _params) do
    meta = %{title: "Welcome to backer"}

    conn
    |> render("forgot_password.html", layout: {BackerWeb.LayoutView, "public.html"}, meta: meta)
  end

  def about_us(conn, _params) do
    meta = %{title: "Welcome to backer"}

    conn
    |> render("about_us.html", layout: {BackerWeb.LayoutView, "public.html"}, meta: meta)
  end

  def faq(conn, _params) do
    meta = %{title: "Welcome to backer"}

    conn
    |> render("faq.html", layout: {BackerWeb.LayoutView, "public.html"}, meta: meta)
  end

  def contact_us(conn, _params) do
    meta = %{title: "Welcome to backer"}
    changeset = Temporary.change_contact(%Contact{})

    conn
    |> render("contact_us.html",
      layout: {BackerWeb.LayoutView, "public.html"},
      meta: meta,
      changeset: changeset
    )
  end

  def contact_us_post(conn, %{"contact" => contact_params}) do
    meta = %{title: "Welcome to backer"}

    case Temporary.create_contact(contact_params) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Contact created successfully.")
        |> render("thanks-contact-us.html",
          layout: {BackerWeb.LayoutView, "public.html"},
          meta: meta
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("contact_us.html",
          layout: {BackerWeb.LayoutView, "public.html"},
          meta: meta,
          changeset: changeset
        )
    end
  end

  def terms(conn, _params) do
    meta = %{title: "Welcome to backer"}

    conn
    |> render("terms.html", layout: {BackerWeb.LayoutView, "public.html"}, meta: meta)
  end

  def privacy_policy(conn, _params) do
    meta = %{title: "Welcome to backer"}

    conn
    |> render("privacy_policy.html", layout: {BackerWeb.LayoutView, "public.html"}, meta: meta)
  end

  def redirector(conn, %{"backer" => username}) do
    backer = Account.get_backer(%{"username" => username})

    case backer do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("page_404.html",
          layout: {BackerWeb.LayoutView, "public.html"}
        )

      other ->
        if backer.is_donee do
          redirect(conn, to: "/donee/" <> username)
        else
          redirect(conn, to: "/backer/" <> username)
        end
    end
  end

  def how_it_works(conn, _params) do
    render(conn, "static_how_it_works.html",
      layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
    )
  end

  def color(conn, params) do
    name = params["name"]
    shape = params["shape"]
    color = params["color"]
    size = params["size"] |> parse_number

    html(conn, """
       #{HashColor.gen_avatar(name, shape: shape, color: color, size: size)}
    """)
  end

  defp parse_number(nil) do
    100
  end

  defp parse_number(string) do
    case Integer.parse(string) do
      {integer, _} -> integer
      :error -> 100
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

  def page400(conn, _params) do
    conn
    |> put_status(:not_found)
    |> render(BackerWeb.DoneeView, "page_404.html",
      page_data: %{title: "400"},
      title: "400",
      layout: {BackerWeb.LayoutView, "public.html"}
    )
  end

  def register_donee(conn, _params) do
    meta = %{title: "Welcome to backer"}
    changeset = Temporary.change_submission(%Submission{})

    conn
    |> render("register_donee.html",
      layout: {BackerWeb.LayoutView, "public.html"},
      changeset: changeset,
      meta: meta
    )
  end

  def register_donee_post(conn, %{"submission" => submission_params}) do
    meta = %{title: "Welcome to backer"}

    case Temporary.create_submission(submission_params) do
      {:ok, submission} ->
        conn
        |> put_flash(:info, "Submission created successfully.")
        |> render("thanks-for-register.html",
          layout: {BackerWeb.LayoutView, "public.html"},
          meta: meta
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)

        conn
        |> render("register_donee.html",
          layout: {BackerWeb.LayoutView, "public.html"},
          changeset: changeset,
          meta: meta
        )
    end

    # conn
    # |> render("register_donee.html",
    #   layout: {BackerWeb.LayoutView, "public.html"},
    #   changeset: changeset,
    #   meta: meta
    # )
  end

  def page403(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render("page_403.html", layout: {BackerWeb.LayoutView, "public.html"})
  end

  def page404(conn, _params) do
    conn
    |> put_status(:not_found)
    |> render("page_404.html", layout: {BackerWeb.LayoutView, "public.html"})
  end

  def page505(conn, _params) do
    text(conn, "505 bro")
  end

  def login(conn, _params) do
    changeset = Account.change_backer(%Backerz{})

    render(conn, "login.html",
      layout: {BackerWeb.LayoutView, "public.html"},
      changeset: changeset
    )
  end

  def sign_up(conn, params) do
    changeset = Account.change_backer(%Backerz{})

    render(conn, "sign_up.html",
      changeset: changeset,
      layout: {BackerWeb.LayoutView, "public.html"}
    )
  end

  def createuser(conn, %{"backer" => params}) do
    case Account.sign_up_backer(params) do
      {:ok, _user} ->
        conn
        |> put_flash(
          :info,
          "Pendaftaran sukses. Silahkan cek dan verifikasi email anda sebelum login."
        )
        |> redirect(to: "/login")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "sign_up.html",
          layout: {BackerWeb.LayoutView, "public.html"},
          changeset: changeset
        )
    end
  end

  def auth(conn, %{"email" => email, "password" => password} = params) do
    case Account.authenticate_backer_front(email, password) do
      {:ok, backer} ->
        if backer.is_email_verified do
          intention_url = get_session(conn, :intention_url)

          if is_nil(intention_url) do
            conn
            |> put_session(:current_backer_id, backer.id)
            |> redirect(to: "/home")
          else
            conn
            |> put_session(:current_backer_id, backer.id)
            |> delete_session(:intention_url)
            |> put_flash(:info, "Great! You've logged in! Now please continue.")
            |> redirect(to: intention_url)
          end
        else
          render(conn, "verify.html",
            layout: {BackerWeb.LayoutView, "public.html"},
            backer: backer
          )
        end

      {:error, reason} ->
        changeset = Account.change_backer(%Backerz{})

        conn
        |> put_flash(:error, reason)
        |> render("login.html",
          layout: {BackerWeb.LayoutView, "public.html"},
          changeset: changeset
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
