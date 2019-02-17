defmodule BackerWeb.PledgerController do
  use BackerWeb, :controller

  alias Backer.Account
  alias Backer.Account.Pledger
  alias Backer.Constant
  alias Backer.Content
  alias Backer.Content.Post
  alias Backer.Finance

  alias Backer.Masterdata

  def index(conn, params) do
    pledgers = Account.list_pledgers(params)
    render(conn, "index.html", pledgers: pledgers)
  end

  def featured(conn, params) do
    pledgers = Account.list_pledgers(params)

    conn
    |> render("public_pledger_list.html",
      pledgers: pledgers,
      layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
    )
  end

  def explore(conn, params) do
    categories = Masterdata.list_categories()

    page_data = %{
      header_img: "/front/images/banner/bg-header3.png",
      title: "Explore"
    }

    conn
    |> render("component_explore.html",
      categories: categories,
      page_data: page_data,
      layout: {BackerWeb.LayoutView, "layout_front_custom_header.html"}
      # layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}      
    )
  end

  def tier(conn, %{"username" => username}) do
    pledger = Account.get_pledger(%{"username" => username})

    case pledger do
      nil ->
        redirect(conn, to: page_path(conn, :page404))

      _ ->
        if pledger.pledger == nil do
          redirect(conn, to: page_path(conn, :page404))
        else
          conn
          |> render("component_tiers.html",
            pledger: pledger,
            active: :overview,
            layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
          )
        end
    end
  end

  def overview(conn, %{"username" => username}) do
    pledger = Account.get_pledger(%{"username" => username})
    backing = Finance.list_all_backerfor(%{"backer_id" => pledger.id})
    backers = Finance.list_active_backers(%{"pledger_id" => pledger.pledger.id})

    case pledger do
      nil ->
        redirect(conn, to: page_path(conn, :page404))

      _ ->
        if pledger.pledger == nil do
          redirect(conn, to: page_path(conn, :page404))
        else
          conn
          |> render("front_overview.html",
            pledger: pledger,
            active: :overview,
            backing: backing,
            backers: backers,
            layout: {BackerWeb.LayoutView, "layout_front_pledger_public.html"}
          )
        end
    end
  end

  def posts(conn, %{"username" => username}) do
    pledger = Account.get_pledger(%{"username" => username})
    backing = Finance.list_all_backerfor(%{"backer_id" => pledger.id})
    backers = Finance.list_active_backers(%{"pledger_id" => pledger.pledger.id})

    case pledger do
      nil ->
        redirect(conn, to: page_path(conn, :page404))

      _ ->
        if pledger.pledger == nil do
          redirect(conn, to: page_path(conn, :page404))
        else
          conn
          |> render("front_posts.html",
            pledger: pledger,
            active: :posts,
            backing: backing,
            backers: backers,
            layout: {BackerWeb.LayoutView, "layout_front_pledger_public.html"}
          )
        end
    end
  end

  def dashboard(conn, _params) do
    conn
    |> render("front_dashboard.html",
      active: :dashboard,
      layout: {BackerWeb.LayoutView, "layout_front_pledger_private.html"}
    )
  end

  def dashboard_post(conn, _params) do
    pledger_id = conn.assigns.current_pledger.pledger_id
    posts = Content.list_posts(%{"pledger_id" => pledger_id}) |> IO.inspect()

    conn
    |> render("front_dashboard_post.html",
      active: :dashboard,
      posts: posts,
      layout: {BackerWeb.LayoutView, "layout_front_pledger_private.html"}
    )
  end

  def dashboard_post_show(conn, %{"id" => id}) do
    post = Content.get_post_simple(conn.assigns.current_pledger.pledger_id, id)

    if post == nil do
      redirect(conn, to: "/400")
    else
      conn
      |> render("front_dashboard_post_show.html",
        post: post,
        active: :dashboard,
        layout: {BackerWeb.LayoutView, "layout_front_pledger_private.html"}
      )
    end

    # pledger_id = conn.assigns.current_pledger.pledger_id
    # posts = Content.list_posts(%{"pledger_id" => pledger_id}) |> IO.inspect
  end

  def dashboard_post_new(conn, _params) do
    pledger_id = conn.assigns.current_pledger.pledger_id
    changeset = Content.change_post(%Post{})
    tiers = Masterdata.list_tiers_for_select(%{"pledger_id" => pledger_id})

    conn
    |> render("front_dashboard_post_new.html",
      changeset: changeset,
      tiers: tiers,
      intent: :create,
      type: :text,
      layout: {BackerWeb.LayoutView, "layout_front_pledger_private.html"}
    )
  end

  def dashboard_post_new_image(conn, _params) do
    pledger_id = conn.assigns.current_pledger.pledger_id
    changeset = Content.change_post(%Post{})
    tiers = Masterdata.list_tiers_for_select(%{"pledger_id" => pledger_id})

    conn
    |> render("front_dashboard_post_new_image.html",
      changeset: changeset,
      tiers: tiers,
      intent: :create,
      type: :image,
      layout: {BackerWeb.LayoutView, "layout_front_pledger_private.html"}
    )
  end

  def dashboard_post_new_video(conn, _params) do
    pledger_id = conn.assigns.current_pledger.pledger_id
    changeset = Content.change_post(%Post{})
    tiers = Masterdata.list_tiers_for_select(%{"pledger_id" => pledger_id})

    conn
    |> render("front_dashboard_post_new_video.html",
      changeset: changeset,
      tiers: tiers,
      intent: :create,
      type: :video,
      layout: {BackerWeb.LayoutView, "layout_front_pledger_private.html"}
    )
  end

  def dashboard_post_create(conn, %{"post" => params}) do
    pledger_id = conn.assigns.current_pledger.pledger_id
    tiers = Masterdata.list_tiers_for_select(%{"pledger_id" => pledger_id})

    post_params = params |> Map.put("pledger_id", pledger_id)

    case Content.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: pledger_path(conn, :dashboard_post))

      {:error, %Ecto.Changeset{changes: %{type: "image"}} = changeset} ->
        conn
        |> render("front_dashboard_post_new_image.html",
          changeset: changeset,
          tiers: tiers,
          layout: {BackerWeb.LayoutView, "layout_front_pledger_private.html"}
        )

      {:error, %Ecto.Changeset{changes: %{type: "video"}} = changeset} ->
        conn
        |> render("front_dashboard_post_new_video.html",
          changeset: changeset,
          tiers: tiers,
          layout: {BackerWeb.LayoutView, "layout_front_pledger_private.html"}
        )

      {:error, %Ecto.Changeset{changes: %{type: "text"}} = changeset} ->
        conn
        |> render("front_dashboard_post_new.html",
          changeset: changeset,
          tiers: tiers,
          layout: {BackerWeb.LayoutView, "layout_front_pledger_private.html"}
        )
    end
  end

  def dashboard_post_edit(conn, %{"id" => id}) do
    post = Content.get_post_simple(conn.assigns.current_pledger.pledger_id, id)
    changeset = Content.change_post(post)
    pledger_id = conn.assigns.current_pledger.pledger_id
    tiers = Masterdata.list_tiers_for_select(%{"pledger_id" => pledger_id})

    if post == nil do
      redirect(conn, to: "/400")
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
        layout: {BackerWeb.LayoutView, "layout_front_pledger_private.html"}
      )
    end
  end

  def dashboard_post_update(conn, %{"id" => id, "post" => post_params}) do
    post = Content.get_post!(id)

    case Content.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: pledger_path(conn, :dashboard_post_show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        pledger_id = conn.assigns.current_pledger.pledger_id
        tiers = Masterdata.list_tiers_for_select(%{"pledger_id" => pledger_id})

        render_target =
          case post.type do
            "image" -> "front_dashboard_post_new_image.html"
            "video" -> "front_dashboard_post_new_video.html"
            _other -> "frontx_dashboard_post_new.html"
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
          layout: {BackerWeb.LayoutView, "layout_front_pledger_private.html"}
        )
    end
  end

  def dashboard_post_delete(conn, %{"id" => id}) do
    post = Content.get_post!(id)
    {:ok, _post} = Content.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: pledger_path(conn, :dashboard_post))
  end

  def dashboard_backers(conn, _params) do
    pledger_id = conn.assigns.current_pledger.pledger_id
    backers = Finance.list_all_backers(%{"pledger_id" => pledger_id}) |> IO.inspect()

    conn
    |> render("front_dashboard_backers.html",
      active: :dashboard,
      backers: backers,
      layout: {BackerWeb.LayoutView, "layout_front_pledger_private.html"}
    )
  end

  # def dashboard_backers(conn, _params) do
  #   pledger = Account.get_pledger(%{"username" => conn.assigns.current_backer.username})
  #   backers = Finance.list_active_backers(%{"pledger_id" => pledger.pledger.id}) |> IO.inspect 
  #         conn
  #         |> render("dashboard_backer.html",
  #           active: :backers,
  #           backers: backers,
  #           layout: {BackerWeb.LayoutView, "dashboard_pledger.html"}
  #         )
  # end 

  def dashboard_earning(conn, _params) do
    conn
    |> render("front_dashboard_earning.html",
      active: :donation,
      layout: {BackerWeb.LayoutView, "layout_front_pledger_private.html"}
    )
  end

  def dashboard_edit_profile(conn, _params) do
    conn
    |> render("dashboard.html",
      active: :edit_profile,
      layout: {BackerWeb.LayoutView, "dashboard_pledger.html"}
    )
  end

  def dashboard_page_setting(conn, _params) do
    conn
    |> render("front_dashboard_page_setting.html",
      active: :page_setting,
      layout: {BackerWeb.LayoutView, "layout_front_pledger_private.html"}
    )
  end

  def backers(conn, %{"username" => username}) do
    pledger = Account.get_pledger(%{"username" => username})
    backers = Finance.list_active_backers(%{"pledger_id" => pledger.pledger.id})

    case pledger do
      nil ->
        redirect(conn, to: page_path(conn, :page404))

      _ ->
        if pledger.pledger == nil do
          redirect(conn, to: page_path(conn, :page404))
        else
          conn
          |> render("front_backers.html",
            pledger: pledger,
            active: :backers,
            backers: backers,
            layout: {BackerWeb.LayoutView, "layout_front_pledger_public.html"}
          )
        end
    end
  end

  def forum(conn, %{"username" => username}) do
    pledger = Account.get_pledger(%{"username" => username})

    case pledger do
      nil ->
        redirect(conn, to: page_path(conn, :page404))

      _ ->
        if pledger.pledger == nil do
          redirect(conn, to: page_path(conn, :page404))
        else
          conn
          |> render("public_pledger_forum.html",
            pledger: pledger,
            active: :forum,
            layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
          )
        end
    end
  end

  def redirector(conn, %{"backer" => username}) do
    backer = Account.get_backer(%{"username" => username})

    case backer do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("page_404.html",
          title: "404",
          layout: {BackerWeb.LayoutView, "layout_front_static.html"}
        )

      other ->
        if backer.is_pledger do
          redirect(conn, to: "/pledger/" <> username)
        else
          redirect(conn, to: "/backer/" <> username)
        end
    end
  end

  def new(conn, _params) do
    backers = Account.list_backers()
    titles = Masterdata.list_titles()
    categories = Masterdata.list_categories()
    changeset = Account.change_pledger(%Pledger{})

    render(conn, "new.html",
      changeset: changeset,
      backers: backers,
      titles: titles,
      categories: categories
    )
  end

  def create(conn, %{"pledger" => pledger_params}) do
    case Account.create_pledger(pledger_params) do
      {:ok, %{pledger: pledger}} ->
        conn
        |> put_flash(:info, "Pledger created successfully.")
        |> redirect(to: pledger_path(conn, :show, pledger))

      {:error, :pledger, %Ecto.Changeset{} = changeset, _} ->
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
    pledger = Account.get_pledger!(id)
    render(conn, "show.html", pledger: pledger)
  end

  def edit(conn, %{"id" => id}) do
    backers = Account.list_backers()
    titles = Masterdata.list_titles()
    categories = Masterdata.list_categories()
    pledger = Account.get_pledger!(id)
    changeset = Account.change_pledger(pledger)

    render(conn, "edit.html",
      pledger: pledger,
      changeset: changeset,
      backers: backers,
      titles: titles,
      categories: categories
    )
  end

  def update(conn, %{"id" => id, "pledger" => pledger_params}) do
    pledger = Account.get_pledger!(id)

    case Account.update_pledger(pledger, pledger_params) do
      {:ok, pledger} ->
        conn
        |> put_flash(:info, "Pledger updated successfully.")
        |> redirect(to: pledger_path(conn, :show, pledger))

      {:error, %Ecto.Changeset{} = changeset} ->
        backers = Account.list_backers()
        titles = Masterdata.list_titles()
        categories = Masterdata.list_categories()

        render(conn, "edit.html",
          pledger: pledger,
          changeset: changeset,
          backers: backers,
          titles: titles,
          categories: categories
        )
    end
  end

  def checkout_post(
        conn,
        %{"amount" => amount, "month" => month, "method" => method, "pledger_id" => pledger_id} =
          params
      ) do
    if conn.assigns.current_backer.id == pledger_id do
      redirect(conn, to: "/400")
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
    # check kalau pledger ga bisa support dirinya sendiri

    if conn.assigns.backer_signed_in? do
      backer = conn.assigns.current_backer
      pledger = Account.get_pledger(%{"username" => username}) |> IO.inspect()

      if pledger == nil do
        redirect(conn, to: "/404")
      else
        case Integer.parse(tier) do
          {number, _} ->
            tiers = Masterdata.list_tiers(%{"pledger_id" => pledger.pledger.id})

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
              pledger: pledger,
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
    pledger = Account.get_pledger!(id)
    {:ok, _pledger} = Account.delete_pledger(pledger)

    conn
    |> put_flash(:info, "Pledger deleted successfully.")
    |> redirect(to: pledger_path(conn, :index))
  end
end
