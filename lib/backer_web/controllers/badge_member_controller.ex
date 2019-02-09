defmodule BackerWeb.BadgeMemberController do
  use BackerWeb, :controller

  alias Backer.Gamification
  alias Backer.Account
  alias Backer.Gamification.BadgeMember

  def new(conn, _params) do
    changeset = Gamification.change_badge_member(%BadgeMember{})
    render(conn, "new.html", changeset: changeset)
  end

  def newmember(conn, %{"badgeid" => badgeid}) do
    backers = Account.list_backers()
    changeset = Gamification.change_badge_member(%BadgeMember{})
    render(conn, "new.html", changeset: changeset, id: badgeid, backers: backers)
  end

  def create(conn, %{"badge_member" => badge_member_params}) do
    case Gamification.create_badge_member(badge_member_params) do
      {:ok, badge_member} ->
        conn
        |> put_flash(:info, "Badge member created successfully.")
        |> redirect(to: badge_path(conn, :show, badge_member.badge_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    badge_member = Gamification.get_badge_member!(id)
    render(conn, "show.html", badge_member: badge_member)
  end

  def edit(conn, %{"id" => id}) do
    badge_member = Gamification.get_badge_member!(id)
    id = badge_member.badge_id
    backers = Account.list_backers()
    changeset = Gamification.change_badge_member(badge_member)

    render(conn, "edit.html",
      badge_member: badge_member,
      id: id,
      changeset: changeset,
      backers: backers
    )
  end

  def update(conn, %{"id" => id, "badge_member" => badge_member_params}) do
    badge_member = Gamification.get_badge_member!(id)

    case Gamification.update_badge_member(badge_member, badge_member_params) do
      {:ok, badge_member} ->
        conn
        |> put_flash(:info, "Badge member updated successfully.")
        |> redirect(to: badge_member_path(conn, :show, badge_member))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", badge_member: badge_member, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    badge_member = Gamification.get_badge_member!(id)
    {:ok, _badge_member} = Gamification.delete_badge_member(badge_member)

    conn
    |> put_flash(:info, "Badge member deleted successfully.")
    |> redirect(to: badge_path(conn, :show, badge_member.badge_id))
  end
end
