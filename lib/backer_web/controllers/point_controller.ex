defmodule BackerWeb.PointController do
  use BackerWeb, :controller

  alias Backer.Gamification
  alias Backer.Gamification.Point

  def index(conn, _params) do
    points = Gamification.list_points()
    render(conn, "index.html", points: points)
  end

  def new(conn, _params) do
    changeset = Gamification.change_point(%Point{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"point" => point_params}) do
    case Gamification.create_point(point_params) do
      {:ok, point} ->
        conn
        |> put_flash(:info, "Point created successfully.")
        |> redirect(to: Router.point_path(conn, :show, point))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    point = Gamification.get_point!(id)
    render(conn, "show.html", point: point)
  end

  def edit(conn, %{"id" => id}) do
    point = Gamification.get_point!(id)
    changeset = Gamification.change_point(point)
    render(conn, "edit.html", point: point, changeset: changeset)
  end

  def update(conn, %{"id" => id, "point" => point_params}) do
    point = Gamification.get_point!(id)

    case Gamification.update_point(point, point_params) do
      {:ok, point} ->
        conn
        |> put_flash(:info, "Point updated successfully.")
        |> redirect(to: Router.point_path(conn, :show, point))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", point: point, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    point = Gamification.get_point!(id)
    {:ok, _point} = Gamification.delete_point(point)

    conn
    |> put_flash(:info, "Point deleted successfully.")
    |> redirect(to: Router.point_path(conn, :index))
  end
end
