defmodule BackerWeb.PledgerController do
  use BackerWeb, :controller

  alias Backer.Account
  alias Backer.Account.Pledger

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

    conn
    |> render("categories_public_list.html",
      categories: categories,
      layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
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
          |> render("public_pledger_tier.html",
            pledger: pledger,
            active: :overview,
            layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
          )
        end
    end
  end

  def checkout(conn, %{"username" => username} = params) do
    tier =
      if Map.has_key?(params, "tier") do
        params["tier"]
      else
        1
      end

    text(conn, tier)
  end

  def overview(conn, %{"username" => username}) do
    pledger = Account.get_pledger(%{"username" => username})

    case pledger do
      nil ->
        redirect(conn, to: page_path(conn, :page404))

      _ ->
        if pledger.pledger == nil do
          redirect(conn, to: page_path(conn, :page404))
        else
          conn
          |> render("public_pledger_overview.html",
            pledger: pledger,
            active: :overview,
            layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
          )
        end
    end
  end

  def posts(conn, %{"username" => username}) do
    pledger = Account.get_pledger(%{"username" => username})

    case pledger do
      nil ->
        redirect(conn, to: page_path(conn, :page404))

      _ ->
        if pledger.pledger == nil do
          redirect(conn, to: page_path(conn, :page404))
        else
          conn
          |> render("public_pledger_posts.html",
            pledger: pledger,
            active: :posts,
            layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
          )
        end
    end
  end

  def backers(conn, %{"username" => username}) do
    pledger = Account.get_pledger(%{"username" => username})

    case pledger do
      nil ->
        redirect(conn, to: page_path(conn, :page404))

      _ ->
        if pledger.pledger == nil do
          redirect(conn, to: page_path(conn, :page404))
        else
          conn
          |> render("public_pledger_backers.html",
            pledger: pledger,
            active: :backers,
            layout: {BackerWeb.LayoutView, "frontend_header_footer.html"}
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
        redirect(conn, to: page_path(conn, :page404))

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
      {:ok, pledger} ->
        conn
        |> put_flash(:info, "Pledger created successfully.")
        |> redirect(to: pledger_path(conn, :show, pledger))

      {:error, %Ecto.Changeset{} = changeset} ->
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
    pledger = Account.get_pledger!(id) |> IO.inspect()
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

  def delete(conn, %{"id" => id}) do
    pledger = Account.get_pledger!(id)
    {:ok, _pledger} = Account.delete_pledger(pledger)

    conn
    |> put_flash(:info, "Pledger deleted successfully.")
    |> redirect(to: pledger_path(conn, :index))
  end
end
