defmodule BackerWeb.TitleController do
  use BackerWeb, :controller

  alias Backer.Masterdata
  alias Backer.Masterdata.Title

  def index(conn, _params) do
    titles = Masterdata.list_titles()
    render(conn, "index.html", titles: titles)
  end

  def new(conn, _params) do
    changeset = Masterdata.change_title(%Title{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"title" => title_params}) do
    case Masterdata.create_title(title_params) do
      {:ok, title} ->
        conn
        |> put_flash(:info, "Title created successfully.")
        |> redirect(to: title_path(conn, :show, title))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    title = Masterdata.get_title!(id)
    render(conn, "show.html", title: title)
  end

  def edit(conn, %{"id" => id}) do
    title = Masterdata.get_title!(id)
    changeset = Masterdata.change_title(title)
    render(conn, "edit.html", title: title, changeset: changeset)
  end

  def update(conn, %{"id" => id, "title" => title_params}) do
    title = Masterdata.get_title!(id)

    case Masterdata.update_title(title, title_params) do
      {:ok, title} ->
        conn
        |> put_flash(:info, "Title updated successfully.")
        |> redirect(to: title_path(conn, :show, title))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", title: title, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    title = Masterdata.get_title!(id)
    {:ok, _title} = Masterdata.delete_title(title)

    conn
    |> put_flash(:info, "Title deleted successfully.")
    |> redirect(to: title_path(conn, :index))
  end
end
