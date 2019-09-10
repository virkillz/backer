defmodule BackerWeb.BackerController do
  use BackerWeb, :controller

  alias Backer.Finance
  alias Backer.Account
  alias Backer.Constant
  alias Backer.Account.Backer, as: Backerz
  alias Backer.Content

  def featured(conn, _params) do
    backers = Account.list_backers()

    page_data = %{
      header_img: "/front/images/banner/bg-header2.png",
      title: "Backers"
    }

    conn
    |> render("public_backer_list.html",
      backers: backers,
      page_data: page_data,
      layout: {BackerWeb.LayoutView, "layout_front_custom_header.html"}
      # layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
    )
  end

  # def redirector(conn, %{"username" => username}) do
  #   backer = Account.get_backer(%{"username" => username})

  #   case backer do
  #     nil ->
  #       conn
  #       |> put_status(:not_found)
  #       |> render(BackerWeb.PledgerView, "page_404.html",
  #         title: "404",
  #         layout: {BackerWeb.LayoutView, "layout_front_static.html"}
  #       )

  #     _ ->
  #       pledgers = Finance.list_active_backerfor(%{"backer_id" => backer.id, "limit" => 4})

  #       if conn.assigns.backer_signed_in? do
  #         if conn.assigns.current_backer.username == username do
  #           redirect(conn, to: backer_path(conn, :timeline, username))
  #         else
  #           redirect(conn, to: backer_path(conn, :overview, username))
  #         end
  #       else
  #         redirect(conn, to: backer_path(conn, :overview, username))
  #       end
  #   end
  # end

  def invoice_display(conn, %{"id" => id, "username" => username}) do
    invoice = Finance.get_invoice!(id) |> IO.inspect()
    invoice_details = Finance.get_invoice_detail(%{"invoice_id" => id}) |> Enum.with_index()
    backer = Account.get_backer(%{"username" => username})

    conn
    |> render("component_invoice.html",
      invoice: invoice,
      invoice_details: invoice_details,
      layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
    )
  end

  def public_overview(conn, %{"username" => username}) do
    backer = Account.get_backer(%{"username" => username})
    pledgers = Finance.list_active_backerfor(%{"backer_id" => backer.id, "limit" => 4})
    recomendation = Account.random_pledger(3)

    case backer do
      nil ->
        redirect(conn, to: Router.page_path(conn, :page404))

      _ ->
        conn
        |> render("front_public_overview.html",
          backer: backer,
          pledgers: pledgers,
          menu: :overview,
          layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
        )
    end
  end

  def overview(conn, _params) do
    backer = Account.get_backer(%{"username" => conn.assigns.current_backer.username})
    pledgers = Finance.list_active_backerfor(%{"backer_id" => backer.id, "limit" => 4})
    recomendation = Account.random_pledger(3)

    case backer do
      nil ->
        redirect(conn, to: Router.page_path(conn, :page404))

      _ ->
        conn
        |> render("front_overview.html",
          backer: backer,
          pledgers: pledgers,
          menu: :overview,
          owner: true,
          layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
        )
    end
  end

  def show_post(conn, %{"id" => id}) do
    backer = conn.assigns.current_backer
    post = Content.get_post(%{"id" => id, "backer_id" => backer.id})

    case backer do
      nil ->
        redirect(conn, to: Router.page_path(conn, :page400))

      _ ->
        conn
        |> render("front_timeline_show.html",
          backer: backer,
          owner: true,
          menu: :timeline,
          post: post,
          layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
        )
    end
  end

  # def home(conn, params) do
  #   backer = conn.assigns.current_backer

  #   {donation, rawposts} = Content.timeline(%{"backer_id" => backer.id})
  #   posts = rawposts |> Enum.map(fn x -> Map.put(x, :current_avatar, backer.avatar) end)

  #   experiment = Content.timeline(backer.id) |> IO.inspect

  #   case backer do
  #     nil ->
  #       redirect(conn, to: page_path(conn, :page404))

  #     _ ->
  #       conn
  #       |> render("front_timeline.html",
  #         backer: backer,
  #         owner: true,
  #         menu: :timeline,
  #         posts: posts,
  #         layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
  #       )
  #   end
  # end

  def home(conn, params) do
    backer = conn.assigns.current_backer

    {donation, rawposts} = Content.timeline(backer.id)
    posts = rawposts |> Enum.map(fn x -> Map.put(x, :current_avatar, backer.avatar) end)

    case backer do
      nil ->
        redirect(conn, to: Router.page_path(conn, :page404))

      _ ->
        conn
        |> render("front_timeline.html",
          backer: backer,
          owner: true,
          menu: :timeline,
          posts: posts,
          layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
        )
    end
  end

  def badges(conn, %{"username" => username}) do
    backer = conn.assigns.current_backer

    case backer do
      nil ->
        redirect(conn, to: Router.page_path(conn, :page404))

      _ ->
        conn
        |> render("public_backer_badges.html",
          backer: backer,
          owner: true,
          layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
        )
    end
  end

  def backing(conn, _paramsms) do
    backer = conn.assigns.current_backer

    pledgers = Finance.list_all_backerfor(%{"backer_id" => backer.id})

    case backer do
      nil ->
        redirect(conn, to: Router.page_path(conn, :page404))

      _ ->
        conn
        |> render("front_backerfor.html",
          backer: backer,
          pledgers: pledgers,
          menu: :backing,
          owner: true,
          layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
        )
    end
  end

  def finance(conn, _params) do
    backer = conn.assigns.current_backer

    balance = Finance.get_balance(%{"backer_id" => conn.assigns.current_backer.id})
    invoices = Finance.list_invoices(%{"backer_id" => conn.assigns.current_backer.id})
    pending_invoice = Enum.count(invoices, fn x -> x.status == "unpaid" end)

    conn
    |> render("front_finance.html",
      backer: conn.assigns.current_backer,
      invoices: invoices,
      balance: balance,
      menu: :finance,
      owner: true,
      pending_invoice: pending_invoice,
      layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
    )
  end

  def backing_history(conn, %{"username" => username}) do
    text(conn, "backing history. put auth")
  end

  def profile_setting(conn, params) do
    # backer = Account.get_backer(%{"username" => username})
    backer = conn.assigns.current_backer

    pledgers = Finance.list_all_backerfor(%{"backer_id" => backer.id})
    changeset = Account.change_backer(backer)

    case backer do
      nil ->
        redirect(conn, to: Router.page_path(conn, :page404))

      _ ->
        conn
        |> render("front_profile_setting.html",
          backer: backer,
          pledgers: pledgers,
          menu: :profile_setting,
          changeset_backer: changeset,
          owner: true,
          layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
        )
    end
  end

  def profile_setting_update(conn, %{"backer" => params}) do
    backer = conn.assigns.current_backer
    pledgers = Finance.list_all_backerfor(%{"backer_id" => backer.id})

    # check if avatar exist
    attrs =
      if params["avatar"] == nil do
        params
      else
        params |> Map.put("avatar", try_upload(params["avatar"], backer.avatar))
      end

    # try to submit real edited data
    case Account.update_backer(backer, attrs) do
      {:ok, backer} ->
        conn
        |> put_flash(:info, "Backer updated successfully.")
        |> redirect(to: "/home/profile-setting")

      {:error, %Ecto.Changeset{} = changeset} ->
        id_types = Constant.accepted_id_kyc()
        render(conn, "edit.html", backer: backer, changeset: changeset, id_types: id_types)

        conn
        |> render("front_profile_setting.html",
          backer: backer,
          pledgers: pledgers,
          menu: :profile_setting,
          changeset_backer: changeset,
          owner: true,
          layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
        )
    end
  end

  defp try_upload(upload_info, old_pic) do
    # the idea is to return invalid data to make the changeset invalid (because avatar expect string type, we give atom)
    case backer_edit_avatar(upload_info, old_pic) do
      {:ok, img_url} -> img_url
      {:error, _changeset} -> :make_invalid
    end
  end

  def ajax_test(conn, params) do
    if conn.assigns.backer_signed_in? do
      {donation, posts} =
        Content.timeline(%{"backer_id" => conn.assigns.current_backer.id}) |> IO.inspect()

      conn |> put_layout(false) |> render("ajax_test.html", posts: posts)
    else
      text(conn, "not authorized")
    end
  end

  def index(conn, params) do
    backers = Account.list_backers(params)
    render(conn, "index.html", backers: backers)
  end

  def new(conn, _params) do
    id_types = Constant.accepted_id_kyc()
    changeset = Account.change_backer(%Backerz{})
    render(conn, "new.html", changeset: changeset, id_types: id_types)
  end

  def create(conn, %{"backer" => backer_params}) do
    IO.inspect(backer_params)
    text(conn, "test berhasil cek console")
    # case Account.create_backer(backer_params) do
    #   {:ok, backer} ->
    #     conn
    #     |> put_flash(:info, "Backer created successfully.")
    #     |> redirect(to: backer_path(conn, :show, backer))

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end
  end

  def show(conn, %{"id" => id}) do
    backer = Account.get_backer!(id)
    pledger = Account.get_backers_pledger(id)
    mutations = Finance.list_mutations()
    render(conn, "show.html", backer: backer, pledger: pledger, mutations: mutations)
  end

  def edit(conn, %{"id" => id}) do
    backer = Account.get_backer!(id)
    id_types = Constant.accepted_id_kyc()
    changeset = Account.change_backer(backer)
    render(conn, "edit.html", backer: backer, changeset: changeset, id_types: id_types)
  end

  def update(conn, %{"id" => id, "backer" => backer_params}) do
    backer = Account.get_backer!(id)
    try_upload = backer_upload_avatar(backer_params["avatar"])

    case try_upload do
      {:ok, img_url} ->
        attrs = Map.put(backer_params, "avatar", img_url) |> IO.inspect()

        # try to submit real photo
        case Account.update_backer(backer, attrs) do
          {:ok, backer} ->
            conn
            |> put_flash(:info, "Backer updated successfully.")
            |> redirect(to: Router.backer_path(conn, :show, backer))

          {:error, %Ecto.Changeset{} = changeset} ->
            IO.inspect("nyampe sini dan ternyata error")
            id_types = Constant.accepted_id_kyc()
            render(conn, "edit.html", backer: backer, changeset: changeset, id_types: id_types)
        end

      {:error, changeset} ->
        id_types = Constant.accepted_id_kyc()
        render(conn, "edit.html", backer: backer, changeset: changeset, id_types: id_types)
    end
  end

  defp backer_upload_avatar(params) do
    # first, check with allowed mime types
    if Stringhelper.accepted_images_mime?(params.content_type) do
      case Cloudex.upload(params.path) do
        {:ok, %Cloudex.UploadedImage{} = result} ->
          {:ok, result.secure_url}

        {:error, reason} ->
          {:error,
           %Ecto.Changeset{
             action: :update,
             changes: %{},
             errors: [avatar: {"File type is invalid", [type: :string, validation: :cast]}],
             data: %Backer.Account.Backer{},
             valid?: false
           }}
      end
    else
      {:error,
       %Ecto.Changeset{
         action: :update,
         changes: %{},
         errors: [avatar: {"File type is invalid", [type: :string, validation: :cast]}],
         data: %Backer.Account.Backer{},
         valid?: false
       }}
    end
  end

  defp backer_edit_avatar(params, old_img) do
    # first, check with allowed mime types
    if Stringhelper.accepted_images_mime?(params.content_type) do
      case Cloudex.upload(params.path) do
        {:ok, %Cloudex.UploadedImage{} = result} ->
          # try to delete old image
          case Stringhelper.is_cloudinary_link?(old_img) do
            {:ok, id} -> Cloudex.delete(id)
            _other -> :nothing
          end

          # give the imag link
          {:ok, result.secure_url}

        {:error, reason} ->
          {:error,
           %Ecto.Changeset{
             action: :update,
             changes: %{},
             errors: [avatar: {"File type is invalid", [type: :string, validation: :cast]}],
             data: %Backer.Account.Backer{},
             valid?: false
           }}
      end
    else
      {:error,
       %Ecto.Changeset{
         action: :update,
         changes: %{},
         errors: [avatar: {"File type is invalid", [type: :string, validation: :cast]}],
         data: %Backer.Account.Backer{},
         valid?: false
       }}
    end
  end

  def delete(conn, %{"id" => id}) do
    backer = Account.get_backer!(id)
    {:ok, _backer} = Account.delete_backer(backer)

    conn
    |> put_flash(:info, "Backer deleted successfully.")
    |> redirect(to: Router.backer_path(conn, :index))
  end
end
