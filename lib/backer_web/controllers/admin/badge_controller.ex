defmodule BackerWeb.BadgeController do
  use BackerWeb, :controller

  alias Backer.Gamification
  alias Backer.Gamification.Badge

  def index(conn, _params) do
    badges = Gamification.list_badges()
    render(conn, "index.html", badges: badges)
  end

  def new(conn, _params) do
    changeset = Gamification.change_badge(%Badge{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"badge" => badge_params}) do
    case Gamification.create_badge(badge_params) do
      {:ok, badge} ->
        conn
        |> put_flash(:info, "Badge created successfully.")
        |> redirect(to: Router.badge_path(conn, :show, badge))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    badge = Gamification.get_badge!(id)
    badge_members = Gamification.list_badge_members(%{"id" => id})
    render(conn, "show.html", badge: badge, badge_members: badge_members)
  end

  def edit(conn, %{"id" => id}) do
    badge = Gamification.get_badge!(id)
    changeset = Gamification.change_badge(badge)
    render(conn, "edit.html", badge: badge, changeset: changeset)
  end

  def update(conn, %{"id" => id, "badge" => badge_params}) do
    badge = Gamification.get_badge!(id)

    case Gamification.update_badge(badge, badge_params) do
      {:ok, badge} ->
        conn
        |> put_flash(:info, "Badge updated successfully.")
        |> redirect(to: Router.badge_path(conn, :show, badge))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", badge: badge, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    badge = Gamification.get_badge!(id)
    {:ok, _badge} = Gamification.delete_badge(badge)

    conn
    |> put_flash(:info, "Badge deleted successfully.")
    |> redirect(to: Router.badge_path(conn, :index))
  end
end
