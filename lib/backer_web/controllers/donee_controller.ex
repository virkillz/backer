defmodule BackerWeb.DoneeController do
  use BackerWeb, :controller

  alias Backer.Account
  alias Backer.Account.Donee
  alias Backer.Constant
  alias Backer.Content
  alias Backer.Content.Post
  alias Backer.Finance
  alias Backer.Finance.Invoice
  alias Backer.Aggregate

  alias Backer.Masterdata

  def index(conn, params) do
    donees = Account.list_donees(params)
    render(conn, "index.html", donees: donees)
  end

  def doneezone_default(conn, _params) do
    redirect(conn, to: "/doneezone/about")
  end

  def doneezone_posts(conn, params) do
    backer_info = conn.assigns.current_backer
    donee_info = conn.assigns.current_donee
    random_donee = Account.get_random_donee(3)

    conn
    |> render("doneezone_timeline.html",
      backer_info: backer_info,
      donee_info: donee_info,
      recommended_donees: random_donee,
      layout: {BackerWeb.LayoutView, "public.html"}
    )
  end

  def doneezone_finance(conn, params) do
    donee = Account.get_donee!(conn.assigns.current_donee.donee_id)
    backer_info = conn.assigns.current_backer
    random_donee = Account.get_random_donee(3)
    invoices = Finance.list_incoming_payment(:donee_id, donee.id)

    conn
    |> render("doneezone_finance.html",
      backer_info: backer_info,
      donee_info: donee,
      invoices: invoices,
      recommended_donees: random_donee,
      layout: {BackerWeb.LayoutView, "public.html"}
    )
  end

  def doneezone_statistic(conn, params) do
    backer_info = conn.assigns.current_backer
    donee = Account.get_donee!(conn.assigns.current_donee.donee_id)
    random_donee = Account.get_random_donee(3)

    conn
    |> render("doneezone_statistic.html",
      backer_info: backer_info,
      donee_info: donee,
      recommended_donees: random_donee,
      layout: {BackerWeb.LayoutView, "public.html"}
    )
  end

  def doneezone_setting(conn, params) do
    backer_info = conn.assigns.current_backer
    donee_info = conn.assigns.current_donee
    random_donee = Account.get_random_donee(3)
    donee = Account.get_donee!(donee_info.donee_id)
    changeset = Account.change_donee(donee)
    user_links = Account.get_user_links_of(backer_info.id)

    option = [
      [key: "Unpublished", value: "unpublished"],
      [key: "Published", value: "published"]
    ]

    conn
    |> render("doneezone_setting.html",
      backer_info: backer_info,
      donee_info: donee,
      option: option,
      recommended_donees: random_donee,
      script: %{wysiwyg: true},
      style: %{wysiwyg: true},
      changeset: changeset,
      user_links: user_links,
      layout: {BackerWeb.LayoutView, "public.html"}
    )
  end

  def doneezone_setting_post(conn, %{"donee" => donee_params}) do
    backer_info = conn.assigns.current_backer
    donee_info = conn.assigns.current_donee
    random_donee = Account.get_random_donee(3)
    donee = Account.get_donee!(donee_info.donee_id) |> IO.inspect()
    background = donee_params["background"]

    updated_params =
      if is_nil(background) do
        donee_params
      else
        donee_params
        |> Map.put(
          "background",
          Backer.Helper.upload_s3_helper(background)
        )
      end

    case Account.update_donee(donee, updated_params) do
      {:ok, new_donee} ->
        changeset = Account.change_donee(new_donee)
        user_links = Account.get_user_links_of(backer_info.id)

        conn
        |> put_flash(:info, "Donee updated successfully.")
        |> render("doneezone_setting.html",
          backer_info: backer_info,
          donee_info: new_donee,
          recommended_donees: random_donee,
          user_links: user_links,
          script: %{wysiwyg: true},
          style: %{wysiwyg: true},
          changeset: changeset,
          layout: {BackerWeb.LayoutView, "public.html"}
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:info, "Something is wrong")
        |> render("doneezone_setting.html",
          backer_info: backer_info,
          donee_info: donee,
          recommended_donees: random_donee,
          script: %{wysiwyg: true},
          style: %{wysiwyg: true},
          changeset: changeset,
          layout: {BackerWeb.LayoutView, "public.html"}
        )
    end
  end

  def statistic(conn, %{"username" => username}) do
    donee = Account.get_donee(%{"username" => username})

    case donee do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        if donee == nil do
          redirect(conn, to: "/404")
        else
          conn
          |> render("public_donee_donate.html",
            donee: donee,
            active: :overview,
            layout: {BackerWeb.LayoutView, "public.html"}
          )
        end
    end
  end

  def my_backer(conn, %{"username" => username}) do
    donee = Account.get_donee(%{"username" => username})

    case donee do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        if donee == nil do
          redirect(conn, to: "/404")
        else
          conn
          |> render("public_donee_donate.html",
            donee: donee,
            active: :overview,
            layout: {BackerWeb.LayoutView, "public.html"}
          )
        end
    end
  end

  def finance(conn, %{"username" => username}) do
    donee = Account.get_donee(%{"username" => username})

    case donee do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        if donee == nil do
          redirect(conn, to: "/404")
        else
          conn
          |> render("public_donee_donate.html",
            donee: donee,
            active: :overview,
            layout: {BackerWeb.LayoutView, "public.html"}
          )
        end
    end
  end

  def setting(conn, %{"username" => username}) do
    donee = Account.get_donee(%{"username" => username})

    case donee do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        if donee == nil do
          redirect(conn, to: "/404")
        else
          conn
          |> render("public_donee_donate.html",
            donee: donee,
            active: :overview,
            layout: {BackerWeb.LayoutView, "public.html"}
          )
        end
    end
  end

  def doneezone_preview(conn, _params) do
    current_backer = conn.assigns.current_backer
    donee = Account.get_donee(%{"username" => current_backer.username})

    random_donee = Account.get_random_donee(4)
    active_backers = Finance.list_active_backers(:donee_id, donee.id)
    backing = Finance.list_all_backerfor(%{"backer_id" => donee.backer.id})
    backers = Finance.list_active_backers(%{"donee_id" => donee.id})

    conn
    |> render("public_donee_about.html",
      donee: donee,
      backing: backing,
      is_visitor_already_backing?: false,
      backers: backers,
      active_backers: active_backers,
      random_donee: random_donee,
      layout: {BackerWeb.LayoutView, "public.html"}
    )
  end

  def render_unpublished(conn, donee) do
    conn
    |> render("unpublished.html",
      donee: donee,
      layout: {BackerWeb.LayoutView, "public.html"}
    )
  end

  def donate(conn, %{"username" => username}) do
    donee = Account.get_donee(%{"username" => username})
    backer = conn.assigns.current_backer
    changeset = Finance.change_invoice(%Invoice{})

    case donee do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        # if not donee
        if donee == nil do
          redirect(conn, to: "/404")
        else
          if donee.status == "unpublished" do
            render_unpublished(conn, donee)
          else
            tiers = Masterdata.list_tiers_for_select(%{"donee_id" => donee.id})

            payment_methods = Backer.Constant.default_payment_methods()
            default_tier = List.first(tiers)
            default_payment_method = List.first(payment_methods)

            # if backer not logged in, go on!
            if is_nil(backer) do
              conn
              |> render("public_donee_donate.html",
                donee: donee,
                changeset: changeset,
                tiers: tiers,
                default_tier: default_tier,
                payment_methods: payment_methods,
                default_payment_method: default_payment_method,
                layout: {BackerWeb.LayoutView, "public.html"}
              )
            else
              # if backer logged in, see if he have active donation going
              if not Finance.is_backer_have_active_donations?(backer.id, donee.id) do
                conn
                |> render("public_donee_donate.html",
                  donee: donee,
                  changeset: changeset,
                  tiers: tiers,
                  default_tier: default_tier,
                  payment_methods: payment_methods,
                  default_payment_method: default_payment_method,
                  layout: {BackerWeb.LayoutView, "public.html"}
                )
              else
                conn
                |> render("donee_donate_forbidden.html",
                  donee: donee,
                  backer: backer,
                  layout: {BackerWeb.LayoutView, "public.html"}
                )
              end
            end
          end
        end
    end
  end

  def doneezone_about(conn, _params) do
    donee_compact = conn.assigns.current_donee
    donee = Account.get_donee!(donee_compact.donee_id)

    case donee do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        random_backer = Account.get_random_backer(4)
        random_donee = Account.get_random_donee(4)

        conn
        |> render("doneezone_about.html",
          donee_info: donee,
          donee: donee,
          random_backer: random_backer,
          recommended_donees: random_donee,
          layout: {BackerWeb.LayoutView, "public.html"}
        )
    end
  end

  def doneezone_backers(conn, _params) do
    donee = Account.get_donee!(conn.assigns.current_donee.donee_id)

    case donee do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        random_backer = Account.get_random_backer(4)
        random_donee = Account.get_random_donee(4)

        active_backers = Finance.list_active_backers(:donee_id, donee.id)

        conn
        |> render("doneezone_backers.html",
          donee_info: donee,
          random_backer: random_backer,
          recommended_donees: random_donee,
          active_backers: active_backers,
          layout: {BackerWeb.LayoutView, "public.html"}
        )
    end
  end

  def about(conn, %{"username" => username}) do
    donee = Account.get_donee(%{"username" => username}) |> IO.inspect()
    current_backer = conn.assigns.current_backer

    case donee do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        if donee == nil do
          redirect(conn, to: Router.page_path(conn, :page404))
        else
          if donee.status == "unpublished" do
            render_unpublished(conn, donee)
          else
            visitor_backing_status =
              if is_nil(current_backer) do
                false
              else
                IO.inspect(current_backer.id)
                IO.inspect(donee.id)

                Finance.is_backer_have_active_donations?(current_backer.id, donee.id)
                |> IO.inspect()
              end

            random_donee = Account.get_random_donee(4)
            active_backers = Aggregate.list_top_backer(donee.id, 4)
            backing = Finance.list_all_backerfor(%{"backer_id" => donee.id})
            backers = Finance.list_active_backers(%{"donee_id" => donee.id})

            conn
            |> render("public_donee_about.html",
              donee: donee,
              backing: backing,
              backers: backers,
              current_backer: current_backer,
              is_visitor_already_backing?: visitor_backing_status,
              active_backers: active_backers,
              random_donee: random_donee,
              layout: {BackerWeb.LayoutView, "public.html"}
            )
          end
        end
    end
  end

  def posts(conn, %{"username" => username}) do
    donee = Account.get_donee(%{"username" => username})

    case donee do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        random_backer = Account.get_random_backer(4)
        random_donee = Account.get_random_donee(4)
        backing = Finance.list_all_backerfor(%{"backer_id" => donee.id})
        backers = Finance.list_active_backers(%{"donee_id" => donee.id})

        posts = Content.timeline_donee(donee.id) |> IO.inspect()

        if donee == nil do
          redirect(conn, to: "/404")
        else
          conn
          |> render("public_donee_posts.html",
            donee: donee,
            random_backer: random_backer,
            random_donee: random_donee,
            layout: {BackerWeb.LayoutView, "public.html"}
          )
        end
    end
  end

  def donate_postx(conn, params) do
    IO.inspect(params)
    text(conn, "check console")
  end

  def donate_post(conn, params) do
    # 1. if backer not logged in, put session and redirect to login with friendly flash message.
    # 2. if backer logged in, check if donee exist. If yes, check if he already a donee. If not exist, throw 403.
    # 3. if all is valid, send params to invoice creation.
    # backer_info = conn.assigns.current_backer
    if conn.assigns.backer_signed_in? do
      donee = Account.get_donee(%{"username" => params["username"]})
      backer = conn.assigns.current_backer

      if not is_nil(donee) do
        if donee.backer.id != backer.id do
          if not Finance.is_backer_have_active_donations?(backer.id, donee.id) do
            if not Finance.is_backer_have_unpaid_invoice?(backer.id, donee.id) do
              attrs =
                params["invoice"]
                |> Map.put("donee_id", donee.id)
                |> Map.put("backer_id", backer.id)
                |> Map.put("type", "backing")

              case Finance.create_donation_invoice(attrs) do
                {:ok, %{invoice: invoice}} ->
                  conn
                  |> put_flash(:info, "Please make Payment.")
                  |> redirect(to: "/backerzone/payment-history")

                {:error, :invoice, %Ecto.Changeset{} = changeset, _} ->
                  conn
                  |> render("public_donee_donate.html",
                    donee: donee,
                    changeset: changeset,
                    layout: {BackerWeb.LayoutView, "public.html"}
                  )

                other ->
                  text(
                    conn,
                    "Unexpected error happened when created Invoice. Sorry for the inconvenience."
                  )
              end
            else
              render(conn, "generic.html",
                data: %{
                  title: "Maaf!",
                  message:
                    "Anda memiliki invoice yang belum terbayarkan kepada Donee ini. Tunggu expired setelah 24 jam sebelum membuat Invoice baru.",
                  btn_text: "Kembali ke halaman utama.",
                  btn_path: "/"
                },
                layout: {BackerWeb.LayoutView, "public.html"}
              )
            end
          else
            redirect(conn, to: "/403")
          end
        else
          render(conn, "generic.html",
            data: %{
              title: "Maaf!",
              message: "Anda tidak bisa mendonasi ke diri sendiri.",
              btn_text: "Kembali ke halaman utama.",
              btn_path: "/"
            },
            layout: {BackerWeb.LayoutView, "public.html"}
          )
        end

        redirect(conn, to: "/403")
      else
      end
    else
      conn
      |> put_session(:intention_url, "/donee/#{params["username"]}/donate")
      |> put_flash(
        :info,
        "Thanks for your kind intention. But you need to login first. Don't worry, we will redirect you to the previous page after login."
      )
      |> redirect(to: "/login")
    end
  end

  def dashboard(conn, _params) do
    conn
    |> render("front_dashboard.html",
      active: :dashboard,
      layout: {BackerWeb.LayoutView, "layout_front_donee_private.html"}
    )
  end

  def dashboard_post(conn, _params) do
    donee_id = conn.assigns.current_donee.donee_id
    posts = Content.list_posts(%{"donee_id" => donee_id}) |> IO.inspect()

    conn
    |> render("front_dashboard_post.html",
      active: :dashboard,
      posts: posts,
      layout: {BackerWeb.LayoutView, "layout_front_donee_private.html"}
    )
  end

  def dashboard_post_show(conn, %{"id" => id}) do
    post = Content.get_post_simple(conn.assigns.current_donee.donee_id, id)

    if post == nil do
      redirect(conn, to: "/404")
    else
      conn
      |> render("front_dashboard_post_show.html",
        post: post,
        active: :dashboard,
        layout: {BackerWeb.LayoutView, "layout_front_donee_private.html"}
      )
    end

    # donee_id = conn.assigns.current_donee.donee_id
    # posts = Content.list_posts(%{"donee_id" => donee_id}) |> IO.inspect
  end

  def dashboard_post_new(conn, _params) do
    donee_id = conn.assigns.current_donee.donee_id
    changeset = Content.change_post(%Post{})
    tiers = Masterdata.list_tiers_for_select(%{"donee_id" => donee_id})

    conn
    |> render("front_dashboard_post_new.html",
      changeset: changeset,
      tiers: tiers,
      intent: :create,
      type: :text,
      layout: {BackerWeb.LayoutView, "layout_front_donee_private.html"}
    )
  end

  def dashboard_post_new_image(conn, _params) do
    donee_id = conn.assigns.current_donee.donee_id
    changeset = Content.change_post(%Post{})
    tiers = Masterdata.list_tiers_for_select(%{"donee_id" => donee_id})

    conn
    |> render("front_dashboard_post_new_image.html",
      changeset: changeset,
      tiers: tiers,
      intent: :create,
      type: :image,
      layout: {BackerWeb.LayoutView, "layout_front_donee_private.html"}
    )
  end

  def dashboard_post_new_video(conn, _params) do
    donee_id = conn.assigns.current_donee.donee_id
    changeset = Content.change_post(%Post{})
    tiers = Masterdata.list_tiers_for_select(%{"donee_id" => donee_id})

    conn
    |> render("front_dashboard_post_new_video.html",
      changeset: changeset,
      tiers: tiers,
      intent: :create,
      type: :video,
      layout: {BackerWeb.LayoutView, "layout_front_donee_private.html"}
    )
  end

  def dashboard_post_create(conn, %{"post" => params}) do
    donee_id = conn.assigns.current_donee.donee_id
    tiers = Masterdata.list_tiers_for_select(%{"donee_id" => donee_id})

    post_params = params |> Map.put("donee_id", donee_id)

    case Content.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Router.donee_path(conn, :dashboard_post))

      {:error, %Ecto.Changeset{changes: %{type: "image"}} = changeset} ->
        conn
        |> render("front_dashboard_post_new_image.html",
          changeset: changeset,
          tiers: tiers,
          layout: {BackerWeb.LayoutView, "layout_front_donee_private.html"}
        )

      {:error, %Ecto.Changeset{changes: %{type: "video"}} = changeset} ->
        conn
        |> render("front_dashboard_post_new_video.html",
          changeset: changeset,
          tiers: tiers,
          layout: {BackerWeb.LayoutView, "layout_front_donee_private.html"}
        )

      {:error, %Ecto.Changeset{changes: %{type: "text"}} = changeset} ->
        conn
        |> render("front_dashboard_post_new.html",
          changeset: changeset,
          tiers: tiers,
          layout: {BackerWeb.LayoutView, "layout_front_donee_private.html"}
        )
    end
  end

  def dashboard_post_edit(conn, %{"id" => id}) do
    post = Content.get_post_simple(conn.assigns.current_donee.donee_id, id)
    changeset = Content.change_post(post)
    donee_id = conn.assigns.current_donee.donee_id
    tiers = Masterdata.list_tiers_for_select(%{"donee_id" => donee_id})

    if post == nil do
      redirect(conn, to: "/404")
    else
      render_target =
        case post.type do
          "image" -> "front_dashboard_post_new_image.html"
          "video" -> "front_dashboard_post_new_video.html"
          _other -> "front_dashboard_post_new.html"
        end

      post_type =
        case post.type do
          "image" -> :image
          "video" -> :video
          _other -> :other
        end

      conn
      |> render(render_target,
        post: post,
        intent: :edit,
        changeset: changeset,
        tiers: tiers,
        type: post_type,
        layout: {BackerWeb.LayoutView, "layout_front_donee_private.html"}
      )
    end
  end

  def dashboard_page_setting(conn, _params) do
    backers = Account.list_backers()
    titles = Masterdata.list_titles()
    categories = Masterdata.list_categories()
    donee = Account.get_donee!(conn.assigns.current_donee.donee_id)
    changeset = Account.change_donee(donee)

    conn
    |> render("front_dashboard_page_setting.html",
      donee: donee,
      changeset: changeset,
      titles: titles,
      categories: categories,
      layout: {BackerWeb.LayoutView, "layout_front_donee_private.html"}
    )
  end

  def dashboard_page_setting_update(conn, params) do
    IO.inspect(params)
  end

  def backers(conn, %{"username" => username}) do
    donee = Account.get_donee(%{"username" => username})
    current_backer = conn.assigns.current_backer
    # backers = Finance.list_active_backers(%{"donee_id" => donee.id})

    case donee do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        active_backers =
          Aggregate.list_top_backer(donee.id, 100)
          |> Enum.filter(fn x -> x.backing_status == "active" end)

        random_donee = Account.get_random_donee(4)

        if donee == nil do
          redirect(conn, to: Router.page_path(conn, :page404))
        else
          if donee.status == "unpublished" do
            render_unpublished(conn, donee)
          else
            visitor_backing_status =
              if is_nil(current_backer) do
                false
              else
                Finance.is_backer_have_active_donations?(current_backer.id, donee.id)
              end

            conn
            |> render("public_donee_backers.html",
              donee: donee,
              active_backers: active_backers,
              random_donee: random_donee,
              is_visitor_already_backing?: visitor_backing_status,
              layout: {BackerWeb.LayoutView, "public.html"}
            )
          end
        end
    end
  end

  def forum(conn, %{"username" => username}) do
    donee = Account.get_donee(%{"username" => username})

    case donee do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        if donee == nil do
          redirect(conn, to: Router.page_path(conn, :page404))
        else
          conn
          |> render("public_donee_forum.html",
            donee: donee,
            active: :forum,
            layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
          )
        end
    end
  end

  def new(conn, _params) do
    backers = Account.list_backers()
    titles = Masterdata.list_titles()
    categories = Masterdata.list_categories()
    changeset = Account.change_donee(%Donee{})

    render(conn, "new.html",
      changeset: changeset,
      backers: backers,
      titles: titles,
      categories: categories
    )
  end

  def create(conn, %{"donee" => donee_params}) do
    case Account.create_donee(donee_params) do
      {:ok, %{donee: donee}} ->
        conn
        |> put_flash(:info, "Donee created successfully.")
        |> redirect(to: Router.donee_path(conn, :show, donee))

      {:error, :donee, %Ecto.Changeset{} = changeset, _} ->
        backers = Account.list_backers()
        titles = Masterdata.list_titles()
        categories = Masterdata.list_categories()

        render(conn, "new.html",
          changeset: changeset,
          backers: backers,
          titles: titles,
          categories: categories
        )
    end
  end

  def show(conn, %{"id" => id}) do
    donee = Account.get_donee!(id)
    render(conn, "show.html", donee: donee)
  end

  def edit(conn, %{"id" => id}) do
    backers = Account.list_backers()
    titles = Masterdata.list_titles()
    categories = Masterdata.list_categories()
    donee = Account.get_donee!(id)
    changeset = Account.change_donee(donee)

    render(conn, "edit.html",
      donee: donee,
      changeset: changeset,
      backers: backers,
      titles: titles,
      categories: categories
    )
  end

  def update(conn, %{"id" => id, "donee" => donee_params}) do
    donee = Account.get_donee!(id)

    case Account.update_donee(donee, donee_params) do
      {:ok, donee} ->
        conn
        |> put_flash(:info, "Donee updated successfully.")
        |> redirect(to: Router.donee_path(conn, :show, donee))

      {:error, %Ecto.Changeset{} = changeset} ->
        backers = Account.list_backers()
        titles = Masterdata.list_titles()
        categories = Masterdata.list_categories()

        render(conn, "edit.html",
          donee: donee,
          changeset: changeset,
          backers: backers,
          titles: titles,
          categories: categories
        )
    end
  end

  def checkout_post(
        conn,
        %{"amount" => amount, "month" => month, "method" => method, "donee_id" => donee_id} =
          params
      ) do
    if conn.assigns.current_backer.id == donee_id do
      redirect(conn, to: "/404")
    else
      new_params =
        params
        |> Map.put("type", "backing")
        |> Map.put("backer_id", conn.assigns.current_backer.id)

      case Finance.create_donation_invoice(new_params) do
        {:ok, %{invoice: invoice}} ->
          redirect(conn,
            to:
              "/backer/" <>
                conn.assigns.current_backer.username <>
                "/invoice/" <> Integer.to_string(invoice.id)
          )

        {:error, :invoice, %Ecto.Changeset{} = changeset, _} ->
          IO.inspect(changeset)
          text(conn, "something is wrong, check console")

        other ->
          IO.inspect(other)
          text(conn, "Ecto Multi give unhandled error, check your console")
      end
    end
  end

  def checkout(conn, %{"tier" => tier, "username" => username}) do
    # check kalau donee ga bisa support dirinya sendiri

    if conn.assigns.backer_signed_in? do
      backer = conn.assigns.current_backer
      donee = Account.get_donee(%{"username" => username}) |> IO.inspect()

      if donee == nil do
        redirect(conn, to: "/404")
      else
        case Integer.parse(tier) do
          {number, _} ->
            tiers = Masterdata.list_tiers(%{"donee_id" => donee.id})

            selected_tier =
              if number > Enum.count(tiers) do
                List.last(tiers)
              else
                index = number - 1
                Enum.at(tiers, index)
              end

            conn
            |> render("component_checkout.html",
              tier: selected_tier,
              donee: donee,
              layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
            )

          _ ->
            redirect(conn, to: "/404")
        end
      end
    else
      conn
      |> put_flash(
        :info,
        "You need to login first."
      )
      |> redirect(to: "/login")
    end
  end

  def delete(conn, %{"id" => id}) do
    donee = Account.get_donee!(id)
    {:ok, _donee} = Account.delete_donee(donee)

    conn
    |> put_flash(:info, "Donee deleted successfully.")
    |> redirect(to: Router.donee_path(conn, :index))
  end
end
