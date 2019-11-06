defmodule BackerWeb.BackerController do
  use BackerWeb, :controller

  alias Backer.Finance
  alias Backer.Account
  alias Backer.Constant
  alias Backer.Account.Backer, as: Backerz
  alias Backer.Content
  alias Backer.Aggregate
  alias Phoenix.LiveView

  def backerzone_default(conn, _params) do
    redirect(conn, to: "/backerzone/timeline-live")

    # backer = conn.assigns.current_backer

    # case backer do
    #   nil ->
    #     redirect(conn, to: "/404")

    #   _ ->
    #     conn
    #     |> render("backerzone_default.html",
    #       backer: backer,
    #       layout: {BackerWeb.LayoutView, "public.html"}
    #     )
    # end
  end

  def reset_counter(conn, _params) do
    backer = conn.assigns.current_backer

    if is_nil(backer) do
      conn |> put_status(:forbidden) |> json(%{success: false, message: "403"})
    else
      get_count_notif = Cachex.get!(:notification, "backer:#{backer.id}")

      count_notif = if is_nil(get_count_notif), do: 0, else: get_count_notif

      Cachex.del(:notification, "backer:#{backer.id}")

      conn |> json(%{success: true, message: "#{count_notif} notification count flushed"})
    end
  end

  def backerzone_my_donee_detail_post(conn, %{"donee_username" => donee_username} = params) do
    donee = Account.get_donee(%{"username" => donee_username})
    backer = conn.assigns.current_backer

    if is_nil(donee) do
      redirect(conn, to: "/403")
    else
      backing_aggregate = Aggregate.get_backingaggregate(backer.id, donee.id)

      if is_nil(backing_aggregate) do
        redirect(conn, to: "/403")
      else
        case Aggregate.update_backing_aggregate(backing_aggregate, params["backing_aggregate"]) do
          {:ok, _} ->
            conn
            |> put_flash(:info, "Pengaturan telah berhasil di perbaharui.")
            |> redirect(to: "/backerzone/my-donee/#{donee.backer.username}")

          _ ->
            conn
            |> put_flash(:error, "Something is wrong.")
            |> redirect(to: "/backerzone/my-donee/#{donee.backer.username}")
        end
      end
    end
  end

  def backerzone_my_donee_detail(conn, %{"donee_username" => donee_username}) do
    backer = conn.assigns.current_backer
    donee = Account.get_donee(%{"username" => donee_username})

    if is_nil(donee) do
      redirect(conn, to: "/404")
    else
      if Finance.is_backer_have_donations_ever?(backer.id, donee.id) do
        list_donation =
          Finance.list_donations(%{"backer_id" => backer.id, "donee_id" => donee.id})

        get_aggregate = Aggregate.get_backingaggregate(backer.id, donee.id)

        backing_aggregate =
          if is_nil(get_aggregate) do
            Aggregate.build_backing_aggregate(backer.id, donee.id)
          else
            get_aggregate
          end

        list_invoices = Finance.list_invoices(%{"backer_id" => backer.id, "donee_id" => donee.id})

        list_donations =
          Finance.list_donations(%{"backer_id" => backer.id, "donee_id" => donee.id})

        if list_donation == [] do
          redirect(conn, to: "/403")
        else
          conn
          |> render("backerzone_my_donee_detail.html",
            backer: backer,
            donee: donee,
            list_invoices: list_invoices,
            list_donations: list_donations,
            backing_aggregate: backing_aggregate,
            changeset: Aggregate.change_backing_aggregate(backing_aggregate),
            layout: {BackerWeb.LayoutView, "public.html"}
          )
        end
      else
        redirect(conn, to: "/403")
      end
    end
  end

  def home(conn, _params) do
    if conn.assigns.current_backer.is_donee do
      redirect(conn, to: "/home/timeline/all")
    else
      redirect(conn, to: "/home/timeline/all")
    end
  end

  def timeline(conn, _params) do
    backer = conn.assigns.current_backer

    # {donation, rawposts} = Content.timeline(backer.id)
    # posts = rawposts |> Enum.map(fn x -> Map.put(x, :current_avatar, backer.avatar) end)

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        random_donee = Account.list_random_donee(3)

        conn
        |> render("backerzone_timeline.html",
          backer: backer,
          random_donee: random_donee,
          layout: {BackerWeb.LayoutView, "public.html"}
        )
    end
  end

  def home_timeline_all(conn, _params) do
    backer = conn.assigns.current_backer

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        random_donee = Account.list_random_donee(3) |> IO.inspect()
        IO.inspect("atas sini apa")

        conn
        |> render("home_timeline_all.html",
          backer: backer,
          random_donee: random_donee,
          layout: {BackerWeb.LayoutView, "public.html"}
        )
    end
  end

  def home_support_my_donees(conn, _params) do
    backer = conn.assigns.current_backer

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        random_donee = Account.list_random_donee(3)
        my_donee_list = Finance.list_my_donee(:backer_id, backer.id)

        conn
        |> render("home_support_my_donee.html",
          backer: backer,
          random_donee: random_donee,
          my_donee_list: my_donee_list,
          layout: {BackerWeb.LayoutView, "public.html"}
        )
    end
  end

  def home_support_my_backers(conn, _params) do
    backer = conn.assigns.current_backer

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        if not backer.is_donee do
          redirect(conn, to: "/403")
        else
          random_donee = Account.list_random_donee(3)
          my_backer_list = Aggregate.list_top_backer(backer.donee.id, 100) |> IO.inspect()

          conn
          |> render("home_support_my_backer.html",
            backer: backer,
            random_donee: random_donee,
            my_backer_list: my_backer_list,
            layout: {BackerWeb.LayoutView, "public.html"}
          )
        end
    end
  end

  def home_support_my_backer_detail(conn, %{"backer_username" => backer_username}) do
    my = conn.assigns.current_backer
    backer = Account.get_backer(%{"username" => backer_username})

    if is_nil(backer) do
      redirect(conn, to: "/404")
    else
      if not my.is_donee do
        IO.inspect("sini bang")
        redirect(conn, to: "/403")
      else
        if Finance.is_backer_have_donations_ever?(backer.id, my.donee.id) do
          list_donation =
            Finance.list_donations(%{"backer_id" => backer.id, "donee_id" => my.donee.id})

          get_aggregate = Aggregate.get_backingaggregate(backer.id, my.donee.id)
          random_donee = Account.list_random_donee(3)

          backing_aggregate =
            if is_nil(get_aggregate) do
              Aggregate.build_backing_aggregate(backer.id, my.donee.id)
            else
              get_aggregate
            end

          list_invoices =
            Finance.list_invoices(%{"backer_id" => backer.id, "donee_id" => my.donee.id})

          list_donations =
            Finance.list_donations(%{"backer_id" => backer.id, "donee_id" => my.donee.id})

          if list_donation == [] do
            IO.inspect("sana bang")
            redirect(conn, to: "/403")
          else
            conn
            |> render("home_support_my_backer_detail.html",
              backer: backer,
              donee: my,
              list_invoices: list_invoices,
              list_donations: list_donations,
              random_donee: random_donee,
              backing_aggregate: backing_aggregate,
              changeset: Aggregate.change_backing_aggregate(backing_aggregate),
              layout: {BackerWeb.LayoutView, "public.html"}
            )
          end
        else
          IO.inspect("situ bang")
          redirect(conn, to: "/403")
        end
      end
    end
  end

  def home_support_my_donee_detail(conn, %{"donee_username" => donee_username}) do
    backer = conn.assigns.current_backer
    donee = Account.get_donee(%{"username" => donee_username})

    if is_nil(donee) do
      redirect(conn, to: "/404")
    else
      if Finance.is_backer_have_donations_ever?(backer.id, donee.id) do
        list_donation =
          Finance.list_donations(%{"backer_id" => backer.id, "donee_id" => donee.id})

        get_aggregate = Aggregate.get_backingaggregate(backer.id, donee.id)
        random_donee = Account.list_random_donee(3)

        backing_aggregate =
          if is_nil(get_aggregate) do
            Aggregate.build_backing_aggregate(backer.id, donee.id)
          else
            get_aggregate
          end

        list_invoices = Finance.list_invoices(%{"backer_id" => backer.id, "donee_id" => donee.id})

        list_donations =
          Finance.list_donations(%{"backer_id" => backer.id, "donee_id" => donee.id})

        if list_donation == [] do
          redirect(conn, to: "/403")
        else
          conn
          |> render("home_support_my_donee_detail.html",
            backer: backer,
            donee: donee,
            list_invoices: list_invoices,
            list_donations: list_donations,
            random_donee: random_donee,
            backing_aggregate: backing_aggregate,
            changeset: Aggregate.change_backing_aggregate(backing_aggregate),
            layout: {BackerWeb.LayoutView, "public.html"}
          )
        end
      else
        redirect(conn, to: "/403")
      end
    end
  end

  def home_settings_donee(conn, _params) do
    backer_info = conn.assigns.current_backer

    if not backer_info.is_donee do
      redirect(conn, to: "/403")
    else
      random_donee = Account.list_random_donee(3)
      donee = Account.get_donee(%{"username" => backer_info.username})
      changeset = Account.change_donee(donee)
      user_links = Account.get_user_links_of(backer_info.id)

      option = [
        [key: "Unpublished", value: "unpublished"],
        [key: "Published", value: "published"]
      ]

      conn
      |> render("home_settings_donee.html",
        backer_info: backer_info,
        donee_info: donee,
        option: option,
        random_donees: random_donee,
        script: %{wysiwyg: true},
        style: %{wysiwyg: true},
        changeset: changeset,
        user_links: user_links,
        layout: {BackerWeb.LayoutView, "public.html"}
      )
    end
  end

  def home_setting_backer_link_post(conn, params) do
    backer = conn.assigns.current_backer

    params
    |> Map.delete("_csrf_token")
    |> Map.delete("_utf8")
    |> Account.batch_user_link_upsert(backer.id)

    conn
    |> put_flash(:info, "Link sudah berhasil disimpan")
    |> redirect(to: "/home/settings/backer")
  end

  def home_setting_backer(conn, _params) do
    backer = conn.assigns.current_backer
    user_links = Account.get_user_links_of(backer.id)

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        random_donees = Account.list_random_donee(3)
        changeset = Account.change_backer(backer)

        conn
        |> render("home_setting_backer.html",
          backer: backer,
          random_donees: random_donees,
          changeset: changeset,
          user_links: user_links,
          layout: {BackerWeb.LayoutView, "public.html"}
        )
    end
  end

  def home_setting_backer_post(conn, %{"backer" => backer_params} = attrs) do
    backer = conn.assigns.current_backer
    avatar = backer_params["avatar"]

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        # build the image url and add to the params to be stored
        updated_params =
          if is_nil(avatar) do
            backer_params
          else
            backer_params
            |> Map.put(
              "avatar",
              upload_s3_helper(avatar)
            )
          end

        case Account.update_backer(backer, updated_params) do
          {:ok, backer} ->
            conn
            |> put_flash(:info, "Backer updated successfully.")
            |> redirect(to: "/home/settings/backer")

          {:error, %Ecto.Changeset{} = changeset} ->
            random_donees = Account.list_random_donee(3)
            user_links = Account.get_user_links_of(backer.id)

            conn
            |> put_flash(:error, "Something is wrong. Check red part below")
            |> render("home_setting_backer.html",
              backer: backer,
              random_donees: random_donees,
              changeset: changeset,
              user_links: user_links,
              layout: {BackerWeb.LayoutView, "public.html"}
            )
        end
    end
  end

  def home_finance_incoming(conn, _params) do
    my = conn.assigns.current_backer

    case my do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        if not my.is_donee do
          redirect(conn, to: "/403")
        else
          donee = Account.get_donee(%{"backer_id" => my.id})
          random_donee = Account.list_random_donee(3)
          invoices = Finance.list_incoming_payment(:donee_id, donee.id) |> IO.inspect()

          conn
          |> render("home_finance_incoming.html",
            backer: my,
            invoices: invoices,
            random_donee: random_donee,
            layout: {BackerWeb.LayoutView, "public.html"}
          )
        end
    end
  end

  def home_finance_outgoing(conn, _params) do
    backer = conn.assigns.current_backer

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        random_donee = Account.list_random_donee(3)
        invoices = Finance.list_invoices(%{"backer_id" => backer.id})

        conn
        |> render("home_finance_outgoing.html",
          backer: backer,
          invoices: invoices,
          random_donee: random_donee,
          layout: {BackerWeb.LayoutView, "public.html"}
        )
    end
  end

  def donee_owner?(backer, invoice) do
    if backer.is_donee do
      donee = Account.get_donee(%{"backer_id" => backer.id})
      invoice.backer_id == donee.id
    else
      false
    end
  end

  def home_finance_invoice(conn, %{"id" => invoice_id}) do
    IO.inspect(conn)
    backer = conn.assigns.current_backer
    invoice = Finance.get_invoice_compact(invoice_id)

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        cond do
          is_nil(invoice) ->
            redirect(conn, to: "/404")

          invoice.backer_id == backer.id || donee_owner?(backer, invoice) ->
            conn
            |> render("home_finance_invoice.html",
              backer: backer,
              invoice: invoice,
              referer: get_req_header(conn, "referer"),
              layout: {BackerWeb.LayoutView, "public.html"}
            )

          true ->
            redirect(conn, to: "/403")
        end
    end
  end

  def placeholder(conn, _params) do
    backer = conn.assigns.current_backer

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        conn
        |> render("backerzone_timeline.html",
          layout: {BackerWeb.LayoutView, "public.html"}
        )
    end
  end

  def backerzone_my_donee_list(conn, _params) do
    backer = conn.assigns.current_backer

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        my_donee_list = Finance.list_my_donee(:backer_id, backer.id)

        random_donees = Account.list_random_donee(3)

        conn
        |> render("backerzone_my_donee_list.html",
          backer: backer,
          my_donee_list: my_donee_list,
          random_donees: random_donees,
          layout: {BackerWeb.LayoutView, "public.html"}
        )
    end
  end

  def backerzone_user_link_post(conn, params) do
    backer = conn.assigns.current_backer

    params
    |> Map.delete("_csrf_token")
    |> Map.delete("_utf8")
    |> Account.batch_user_link_upsert(backer.id)

    conn
    |> put_flash(:info, "Link sudah berhasil disimpan")
    |> redirect(to: "/backerzone/profile-setting")
  end

  def backerzone_profile_setting(conn, _params) do
    backer = conn.assigns.current_backer
    user_links = Account.get_user_links_of(backer.id)

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        random_donees = Account.list_random_donee(3)
        changeset = Account.change_backer(backer)

        conn
        |> render("backerzone_profile_setting.html",
          backer: backer,
          random_donees: random_donees,
          changeset: changeset,
          user_links: user_links,
          layout: {BackerWeb.LayoutView, "public.html"}
        )
    end
  end

  def upload_s3_helper(file) do
    file_uuid = Ecto.UUID.generate()
    image_filename = file.filename
    unique_filename = "#{file_uuid}-#{image_filename}"
    {:ok, image_binary} = File.read(file.path)

    if String.contains?(file.content_type, "image") do
      bucket_name = System.get_env("BUCKET_NAME")

      image =
        ExAws.S3.put_object(bucket_name, unique_filename, image_binary)
        |> ExAws.request!()

      "https://#{bucket_name}.s3.amazonaws.com/#{bucket_name}/#{unique_filename}"
    else
      "error"
    end
  end

  def backerzone_notifications(conn, _params) do
    backer = conn.assigns.current_backer

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        random_donees = Account.list_random_donee(3)
        list_notifications = Content.list_notification_of(backer.id)

        conn
        |> render("private_notification.html",
          backer: backer,
          notifications: list_notifications,
          layout: {BackerWeb.LayoutView, "public.html"}
        )
    end
  end

  def backerzone_notification_api(conn, _params) do
    backer = conn.assigns.current_backer

    notifs =
      Content.list_notification_of(backer.id)
      |> Enum.map(fn x ->
        %{
          "content" => x.content,
          "icon" => x.icon,
          "thumbnail" => x.thumbnail,
          "ago" => Stringhelper.format_ago(x.inserted_at),
          "id" => x.id |> Integer.to_string(),
          "is_read" => x.is_read
        }
      end)
      |> Enum.take(5)

    json(conn, notifs)
  end

  def backerzone_notification_forwarder(conn, %{"id" => id}) do
    get_notification = Content.get_notification(id)
    backer = conn.assigns.current_backer

    case get_notification do
      nil ->
        redirect(conn, to: "/404")

      notification ->
        if notification.user_id != backer.id do
          redirect(conn, to: "/403")
        else
          Content.mark_notification_as_read(notification)

          case notification.type do
            "invoice" ->
              redirect(conn, to: "/backerzone/invoice/#{notification.other_ref_id}")

            "receive_payment" ->
              redirect(conn, to: "/doneezone/finance")

            _ ->
              text(conn, "Unknown type of notification")
          end
        end
    end
  end

  def backerzone_profile_setting_post(conn, %{"backer" => backer_params} = attrs) do
    backer = conn.assigns.current_backer
    avatar = backer_params["avatar"]

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        # build the image url and add to the params to be stored
        updated_params =
          if is_nil(avatar) do
            backer_params
          else
            backer_params
            |> Map.put(
              "avatar",
              upload_s3_helper(avatar)
            )
          end

        case Account.update_backer(backer, updated_params) do
          {:ok, backer} ->
            conn
            |> put_flash(:info, "Backer updated successfully.")
            |> redirect(to: "/backerzone/profile-setting")

          {:error, %Ecto.Changeset{} = changeset} ->
            random_donees = Account.list_random_donee(3)

            conn
            |> put_flash(:error, "Something is wrong. Check red part below")
            |> render("backerzone_profile_setting.html",
              backer: backer,
              random_donees: random_donees,
              changeset: changeset,
              layout: {BackerWeb.LayoutView, "public.html"}
            )

            # id_types = Constant.accepted_id_kyc()
            # render(conn, "edit.html", backer: backer, changeset: changeset, id_types: id_types)
        end
    end
  end

  def backerzone_payment_history(conn, %{"donee_id" => donee_id}) do
    backer = conn.assigns.current_backer

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        invoices = Finance.list_invoices(%{"backer_id" => backer.id, "donee_id" => donee_id})

        random_donees = Account.list_random_donee(3)

        conn
        |> render("backerzone_payment_history.html",
          backer: backer,
          invoices: invoices,
          random_donees: random_donees,
          layout: {BackerWeb.LayoutView, "public.html"}
        )
    end
  end

  def backerzone_payment_history(conn, _params) do
    backer = conn.assigns.current_backer

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        invoices = Finance.list_invoices(%{"backer_id" => backer.id})

        random_donees = Account.list_random_donee(3)

        conn
        |> render("backerzone_payment_history.html",
          backer: backer,
          invoices: invoices,
          random_donees: random_donees,
          layout: {BackerWeb.LayoutView, "public.html"}
        )
    end
  end

  def backerzone_invoice_detail(conn, %{"id" => invoice_id}) do
    backer = conn.assigns.current_backer
    invoice = Finance.get_invoice_compact(invoice_id)

    case backer do
      nil ->
        redirect(conn, to: "/404")

      _ ->
        cond do
          is_nil(invoice) ->
            redirect(conn, to: "/404")

          invoice.backer_id != backer.id ->
            redirect(conn, to: "/403")

          true ->
            # text(conn, "blah")
            conn
            |> render("backerzone_invoice_detail.html",
              backer: backer,
              invoice: invoice,
              layout: {BackerWeb.LayoutView, "public.html"}
            )
        end
    end
  end

  def public_profile(conn, %{"username" => username}) do
    case Account.get_backer(%{"username" => username}) do
      nil ->
        redirect(conn, to: "/404")

      backer ->
        user_links = Account.get_user_links_of(backer.id)
        # list_my_active_donee = Finance.list_my_active_donee(:backer_id, backer.id)
        list_my_active_donee = Aggregate.list_donee_of_a_backer(backer.id, 100)
        count_all_donee = Finance.count_my_donee(:backer_id, backer.id)

        conn
        |> render("public_backer_profile.html",
          backer: backer,
          user_links: user_links,
          active_donee: list_my_active_donee,
          count_all_donee: count_all_donee,
          layout: {BackerWeb.LayoutView, "public.html"}
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

  def ajax_test(conn, _params) do
    if conn.assigns.backer_signed_in? do
      {donation, posts} = Content.timeline(%{"backer_id" => conn.assigns.current_backer.id})

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
    donee = Account.get_backers_donee(id)
    mutations = Finance.list_mutations()
    render(conn, "show.html", backer: backer, donee: donee, mutations: mutations)
  end

  def edit(conn, %{"id" => id}) do
    backer = Account.get_backer!(id)
    id_types = Constant.accepted_id_kyc()
    changeset = Account.change_backer(backer)
    render(conn, "edit.html", backer: backer, changeset: changeset, id_types: id_types)
  end

  def update(conn, %{"id" => id, "backer" => backer_params}) do
    backer = Account.get_backer!(id)

    case Account.update_backer(backer, backer_params) do
      {:ok, backer} ->
        conn
        |> put_flash(:info, "Backer updated successfully.")
        |> redirect(to: Router.backer_path(conn, :show, backer))

      {:error, %Ecto.Changeset{} = changeset} ->
        id_types = Constant.accepted_id_kyc()
        render(conn, "edit.html", backer: backer, changeset: changeset, id_types: id_types)
    end
  end

  def update_x(conn, %{"id" => id, "backer" => backer_params}) do
    backer = Account.get_backer!(id)
    try_upload = backer_upload_avatar(backer_params["avatar"])

    case try_upload do
      {:ok, img_url} ->
        attrs = Map.put(backer_params, "avatar", img_url)

        # try to submit real photo
        case Account.update_backer(backer, attrs) do
          {:ok, backer} ->
            conn
            |> put_flash(:info, "Backer updated successfully.")
            |> redirect(to: Router.backer_path(conn, :show, backer))

          {:error, %Ecto.Changeset{} = changeset} ->
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

        {:error, _reason} ->
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

        {:error, _reason} ->
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

  def backerzone_timeline_live(conn, _params) do
    backer = conn.assigns.current_backer

    conn
    |> put_layout("backerzone_live_layout.html")
    |> assign(:backer, backer)
    |> assign(:random_donees, Account.list_random_donee(3))
    |> LiveView.Controller.live_render(BackerWeb.BackerzoneTimelineLive,
      session: %{backer: backer}
    )
  end

  def backerzone_timeline_post_live(conn, %{"post_id" => post_id}) do
    backer = conn.assigns.current_backer

    # first is to ensure the person is deserved the post. Either by check whether its public or backing.

    # id is integer?
    case Integer.parse(post_id) do
      {id, _} ->
        case Content.get_post(id) do
          nil ->
            redirect(conn, to: "/404")

          post ->
            # is it public post?
            if post.min_tier == 0 do
              render_post_detail(conn, post)
            else
              if Aggregate.is_backer_active?(backer.id, post.donee_id) do
                render_post_detail(conn, post)
              else
                redirect(conn, to: "/403")
              end
            end
        end

      :error ->
        redirect(conn, to: "/404")
    end
  end

  defp render_post_detail(conn, post) do
    backer = conn.assigns.current_backer

    conn
    |> put_layout("backerzone_live_layout.html")
    |> assign(:backer, backer)
    |> assign(:random_donees, Account.list_random_donee(3))
    |> LiveView.Controller.live_render(BackerWeb.BackerzonePostLive,
      session: %{backer: backer, post: post}
    )
  end
end
