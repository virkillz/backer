defmodule BackerWeb.CategoryController do
  use BackerWeb, :controller

  alias Backer.Masterdata
  alias Backer.Account
  alias Backer.Masterdata.Category

  def index(conn, _params) do
    categories = Masterdata.list_categories()
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Masterdata.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def list_donee(conn, %{"id" => id}) do
    category = Masterdata.get_category!(id)
    donees = Account.get_donee(%{"category_id" => id})

    page_data = %{
      header_img:
        "https://images.pexels.com/photos/1212829/pexels-photo-1212829.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      title: category.name
    }

    conn
    |> render("category_donee_list.html",
      category: category,
      donees: donees,
      page_data: page_data,
      layout: {BackerWeb.LayoutView, "layout_front_custom_header.html"}
    )
  end

  def create(conn, %{"category" => category_params}) do
    case Masterdata.create_category(category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: Router.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Masterdata.get_category!(id)
    render(conn, "show.html", category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = Masterdata.get_category!(id)
    changeset = Masterdata.change_category(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Masterdata.get_category!(id)

    case Masterdata.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: Router.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Masterdata.get_category!(id)
    {:ok, _category} = Masterdata.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Router.category_path(conn, :index))
  end
end
