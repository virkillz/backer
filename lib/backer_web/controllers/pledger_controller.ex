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
    pledgers = Account.list_pledgers(params) |> IO.inspect
    conn |> render("public_pledger_list.html", pledgers: pledgers, layout: {BackerWeb.LayoutView, "header_footer_non_login_frontend.html"})      
  end  


  def profile(conn, %{"username" => username}) do
    pledger = Account.get_pledger(%{"username" => username}) |> IO.inspect

    case pledger do
      nil -> redirect(conn, to: page_path(conn, :page404))
      _ -> if pledger.pledger == nil do
            redirect(conn, to: page_path(conn, :page404))
          else
            conn |> render("profile_public_overview.html", pledger: pledger, layout: {BackerWeb.LayoutView, "header_footer_non_login_frontend.html"})             
      end
    end
      
  end

  def redirector(conn, %{"backer" => username}) do
    backer = Account.get_backer(%{"username" => username})
    case backer do
      nil -> redirect(conn, to: page_path(conn, :page404))

      other -> if backer.is_pledger do
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
    render(conn, "new.html", changeset: changeset, backers: backers, titles: titles, categories: categories)
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
        render(conn, "new.html", changeset: changeset, backers: backers, titles: titles, categories: categories)
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
    render(conn, "edit.html", pledger: pledger, changeset: changeset, backers: backers, titles: titles, categories: categories)
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
        render(conn, "edit.html", pledger: pledger, changeset: changeset, backers: backers, titles: titles, categories: categories)
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
