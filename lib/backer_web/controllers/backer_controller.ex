defmodule BackerWeb.BackerController do
  use BackerWeb, :controller

  alias Backer.Finance
  alias Backer.Account
  alias Backer.Constant
  alias Backer.Account.Backer

  def featured(conn, _params) do
    backers = Account.list_backers()

    conn
    |> render("public_backer_list.html",
      backers: backers,
      layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
    )
  end

  def redirector(conn, %{"username" => username}) do
    backer = Account.get_backer(%{"username" => username})

    case backer do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(BackerWeb.PledgerView, "page_404.html",
          title: "404",
          layout: {BackerWeb.LayoutView, "layout_front_static.html"}
        )

      _ ->
        pledgers = Finance.list_active_backerfor(%{"backer_id" => backer.id, "limit" => 4})

        if conn.assigns.backer_signed_in? do
          if conn.assigns.current_backer.username == username do
            redirect(conn, to: backer_path(conn, :timeline, username))
          else
            redirect(conn, to: backer_path(conn, :overview, username))
          end
        else
          redirect(conn, to: backer_path(conn, :overview, username))
        end
    end
  end

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

  def overview(conn, %{"username" => username}) do
    backer = Account.get_backer(%{"username" => username})
    pledgers = Finance.list_active_backerfor(%{"backer_id" => backer.id, "limit" => 4})
    IO.inspect("ini lho")
    recomendation = Account.random_pledger(2) |> IO.inspect()

    case backer do
      nil ->
        redirect(conn, to: page_path(conn, :page404))

      _ ->
        conn
        |> render("front_overview.html",
          backer: backer,
          pledgers: pledgers,
          layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
        )
    end
  end

  def timeline(conn, %{"username" => username}) do
    backer = Account.get_backer(%{"username" => username})

    case backer do
      nil ->
        redirect(conn, to: page_path(conn, :page404))

      _ ->
        conn
        |> render("front_timeline.html",
          backer: backer,
          layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
        )

        # conn
        # |> render("private_backer_timeline.html",
        #   backer: backer,
        #   layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
        # )
    end
  end

  def badges(conn, %{"username" => username}) do
    backer = Account.get_backer(%{"username" => username})

    case backer do
      nil ->
        redirect(conn, to: page_path(conn, :page404))

      _ ->
        conn
        |> render("public_backer_badges.html",
          backer: backer,
          layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
        )
    end
  end

  def backerfor(conn, %{"username" => username}) do
    backer = Account.get_backer(%{"username" => username})

    pledgers = Finance.list_all_backerfor(%{"backer_id" => backer.id})

    case backer do
      nil ->
        redirect(conn, to: page_path(conn, :page404))

      _ ->
        conn
        |> render("front_backerfor.html",
          backer: backer,
          pledgers: pledgers,
          layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
        )
    end
  end

  def finance(conn, %{"username" => username}) do
    backer = Account.get_backer(%{"username" => username})

    case backer do
      nil ->
        redirect(conn, to: page_path(conn, :page404))

      _ ->
        if conn.assigns.current_backer.username != username do
          redirect(conn, to: page_path(conn, :page404))
        else
          balance = Finance.get_balance(%{"backer_id" => conn.assigns.current_backer.id})
          invoices = Finance.list_invoices(%{"backer_id" => conn.assigns.current_backer.id})
          pending_invoice = Enum.count(invoices, fn x -> x.status == "unpaid" end)

          conn
          |> render("component_finance.html",
            backer: conn.assigns.current_backer,
            invoices: invoices,
            balance: balance,
            pending_invoice: pending_invoice,
            layout: {BackerWeb.LayoutView, "layout_front_focus.html"}
          )
        end
    end
  end

  def backing_history(conn, %{"username" => username}) do
    text(conn, "backing history. put auth")
  end

  def profile_setting(conn, %{"username" => username}) do
    text(conn, "profile setting. put auth")
  end

  def ajax_test(conn, params) do
    IO.inspect(params)
    conn |> put_layout(false) |> render("ajax_test.html")
  end

  def index(conn, params) do
    backers = Account.list_backers(params)
    render(conn, "index.html", backers: backers)
  end

  def new(conn, _params) do
    id_types = Constant.accepted_id_kyc()
    changeset = Account.change_backer(%Backer{})
    render(conn, "new.html", changeset: changeset, id_types: id_types)
  end

  def create(conn, %{"backer" => backer_params}) do
    case Account.create_backer(backer_params) do
      {:ok, backer} ->
        conn
        |> put_flash(:info, "Backer created successfully.")
        |> redirect(to: backer_path(conn, :show, backer))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
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

    case Account.update_backer(backer, backer_params) do
      {:ok, backer} ->
        conn
        |> put_flash(:info, "Backer updated successfully.")
        |> redirect(to: backer_path(conn, :show, backer))

      {:error, %Ecto.Changeset{} = changeset} ->
        id_types = Constant.accepted_id_kyc()
        render(conn, "edit.html", backer: backer, changeset: changeset, id_types: id_types)
    end
  end

  def delete(conn, %{"id" => id}) do
    backer = Account.get_backer!(id)
    {:ok, _backer} = Account.delete_backer(backer)

    conn
    |> put_flash(:info, "Backer deleted successfully.")
    |> redirect(to: backer_path(conn, :index))
  end
end
