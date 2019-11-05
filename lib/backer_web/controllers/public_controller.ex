defmodule BackerWeb.PublicController do
  use BackerWeb, :controller

  alias Backer.Account
  alias Backer.Account.User
  alias Backer.Account.Backer, as: Backerz
  alias Backer.Temporary.Submission
  alias Backer.Temporary
  alias Backer.Temporary.Contact
  alias Backer.Content

  def index(conn, _params) do
    meta = %{title: "Welcome to backer"}

    meta_attrs = [
      %{name: "keywords", content: "........"},
      %{name: "description", content: "........."},
      %{property: "og:image", content: "......"}
    ]

    random_donee = Account.list_random_donee(6) |> IO.inspect()
    highlight_donee = Account.get_highlight_donee_homepage()

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

  def search(conn, %{"q" => q, "filter" => filter}) do
    meta = %{title: "Welcome to backer"}

    query = "%#{q}%"

    search_result_backer =
      if filter == "backer" do
        Account.search_backer(query)
      else
        []
      end

    search_result_donee =
      if filter == "donee" do
        Account.search_donee(query)
      else
        []
      end

    conn
    |> render("search_result.html",
      layout: {BackerWeb.LayoutView, "public.html"},
      search_term: q,
      filter: filter,
      search_result_backer: search_result_backer,
      search_result_donee: search_result_donee,
      meta: meta
    )
  end

  def search(conn, %{"q" => q}) do
    meta = %{title: "Welcome to backer"}

    query = "%#{q}%"
    search_result_backer = Account.search_backer(query)
    search_result_donee = Account.search_donee(query)

    conn
    |> render("search_result.html",
      layout: {BackerWeb.LayoutView, "public.html"},
      search_term: q,
      filter: "all",
      search_result_backer: search_result_backer,
      search_result_donee: search_result_donee,
      meta: meta
    )
  end

  def search(conn, _params) do
    meta = %{title: "Welcome to backer"}

    conn
    |> render("search_form.html",
      layout: {BackerWeb.LayoutView, "public.html"},
      meta: meta
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
      recaptcha: true,
      changeset: changeset
    )
  end

  def contact_us_post(conn, %{"contact" => contact_params} = params) do
    case Backer.Helper.verify_recaptcha(params["g-recaptcha-response"]) do
      :ok ->
        contact_us_post_continue(conn, contact_params)

      :wrongcaptcha ->
        conn
        |> put_flash(:error, "Oops, wrong captcha")
        |> redirect(to: "/contact-us")

      _ ->
        contact_us_post_continue(conn, contact_params)
    end
  end

  defp contact_us_post_continue(conn, contact_params) do
    meta = %{title: "Welcome to backer"}

    case Temporary.create_contact(contact_params) do
      {:ok, _contact} ->
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
          recaptcha: true,
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

      _other ->
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

        render(conn, "generic.html",
          data: %{
            title: "Berhasil!",
            message: "Email anda sudah terverifikasi. Silahkan login.",
            btn_text: "Login",
            btn_path: "/login"
          },
          layout: {BackerWeb.LayoutView, "public.html"}
        )

      {:error, _} ->
        render(conn, "generic.html",
          data: %{
            title: "Ups!",
            message: "Kode verifikasi yang digunakan tidak valid",
            btn_text: "Kembali ke Halaman Utama",
            btn_path: "/"
          },
          layout: {BackerWeb.LayoutView, "public.html"}
        )

      {:already, _} ->
        render(conn, "generic.html",
          data: %{
            title: "Ups!",
            message: "Email anda sudah terverifikasi. Silahkan login.",
            btn_text: "Login",
            btn_path: "/login"
          },
          layout: {BackerWeb.LayoutView, "public.html"}
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
  def static_page(conn, _params) do
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
      recaptcha: true,
      meta: meta
    )
  end

  def register_donee_post(conn, %{"submission" => submission_params} = params) do
    case Backer.Helper.verify_recaptcha(params["g-recaptcha-response"]) do
      :ok ->
        register_donee_post_continue(conn, submission_params)

      :wrongcaptcha ->
        conn
        |> put_flash(:error, "Oops, wrong captcha")
        |> redirect(to: "/register_donee")

      _ ->
        register_donee_post_continue(conn, submission_params)
    end
  end

  def register_donee_post_continue(conn, submission_params) do
    meta = %{title: "Welcome to backer"}

    case Temporary.create_submission(submission_params) do
      {:ok, _submission} ->
        conn
        |> put_flash(:info, "Submission created successfully.")
        |> render("thanks-for-register.html",
          layout: {BackerWeb.LayoutView, "public.html"},
          meta: meta
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("register_donee.html",
          layout: {BackerWeb.LayoutView, "public.html"},
          changeset: changeset,
          recaptcha: true,
          meta: meta
        )
    end
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
      changeset: changeset,
      recaptcha: true
    )
  end

  def sign_up(conn, _params) do
    changeset = Account.change_backer(%Backerz{})

    render(conn, "sign_up.html",
      changeset: changeset,
      recaptcha: true,
      layout: {BackerWeb.LayoutView, "public.html"}
    )
  end

  def createuser(conn, %{"backer" => params} = all_params) do
    case Backer.Helper.verify_recaptcha(all_params["g-recaptcha-response"]) do
      :ok ->
        createuser_continue(conn, params)

      :wrongcaptcha ->
        conn
        |> put_flash(:error, "Oops, wrong captcha")
        |> redirect(to: "/sign_up")

      _ ->
        createuser_continue(conn, params)
    end
  end

  def createuser_continue(conn, params) do
    case Account.sign_up_backer(params) do
      {:ok, user} ->
        SendMail.verification(user.email, user.display_name, user.email_verification_code)

        conn
        |> put_flash(
          :info,
          "Pendaftaran sukses. Silahkan cek dan verifikasi email anda sebelum login."
        )
        |> redirect(to: "/login")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "sign_up.html",
          layout: {BackerWeb.LayoutView, "public.html"},
          changeset: changeset,
          recaptcha: true
        )
    end
  end

  def auth(conn, %{"email" => email, "password" => password} = params) do
    case Backer.Helper.verify_recaptcha(params["g-recaptcha-response"]) do
      :ok ->
        auth_continue(conn, email, password)

      :wrongcaptcha ->
        conn
        |> put_flash(:error, "Oops, wrong captcha")
        |> redirect(to: "/login")

      _ ->
        auth_continue(conn, email, password)
    end
  end

  def auth_continue(conn, email, password) do
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
          recaptcha: true,
          layout: {BackerWeb.LayoutView, "public.html"},
          changeset: changeset
        )
    end
  end

  def forgot_password_post(conn, %{"email" => email}) do
    # if user founded, generate new recovery key
    backer = Account.get_backer(%{"email" => email})

    if backer != nil do
      new_code = Ecto.UUID.generate()
      params = %{"password_recovery_code" => new_code}
      Account.update_backer(backer, params)

      spawn(fn -> SendMail.send_reset_password(backer.email, backer.display_name, new_code) end)
    end

    data = %{
      title: "Done!",
      image: "/assets/images/ouch/flame-searching.png",
      message:
        "If we found your email in our database, we will sent the password recodery link. Please check your email.",
      btn_text: "Kembali ke Halaman Utama",
      btn_path: "/"
    }

    render(conn, "generic.html",
      data: data,
      layout: {BackerWeb.LayoutView, "public.html"}
    )
  end

  def reset_password(conn, %{"code" => code}) do
    backer = Account.get_backer(%{"password_recovery_code" => code})
    changeset = Account.change_password_backer(%Backerz{})

    if backer == nil do
      data = %{
        title: "Invalid",
        message: "Link yang anda gunakan tidak ditemukan atau sudah tidak berlaku.",
        btn_path: "/",
        btn_text: "Kembali ke halaman utama"
      }

      render(conn, "generic.html", layout: {BackerWeb.LayoutView, "public.html"}, data: data)
    else
      render(conn, "reset_password.html",
        code: code,
        changeset: changeset,
        layout: {BackerWeb.LayoutView, "public.html"}
      )
    end
  end

  def reset_password(conn, _params) do
    redirect(conn, to: "/404")
  end

  def reset_password_post(conn, %{"code" => code} = params) do
    backer = Account.get_backer(%{"password_recovery_code" => code})

    if backer == nil do
      data = %{
        title: "Forbidden",
        message: "Please don't do that.",
        btn_path: "/",
        btn_text: "Kembali ke halaman utama"
      }

      conn
      |> put_status(:forbidden)
      |> render("generic.html", layout: {BackerWeb.LayoutView, "public.html"}, data: data)
    else
      case Account.update_password_backer(backer, params) do
        {:ok, _user} ->
          conn
          |> put_flash(
            :info,
            "Password telah berhasil dirubah. Silahkan login kembali"
          )
          |> redirect(to: "/login")

        {:error, %Ecto.Changeset{}} ->
          conn
          |> put_flash(:error, "Password tidak sama.")
          |> render("reset_password.html",
            code: params["code"],
            layout: {BackerWeb.LayoutView, "public.html"}
          )
      end
    end
  end

  # Delete hapus when finish testing
  def hapus_notification(conn, _params) do
    notifs =
      Content.list_notification_of(1)
      |> Enum.map(fn x ->
        %{
          "content" => x.content,
          "icon" => x.icon,
          "thumbnail" => x.thumbnail,
          "ago" => Stringhelper.format_ago(x.inserted_at),
          "id" => x.id |> Integer.to_string()
        }
      end)

    json(conn, notifs)
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
