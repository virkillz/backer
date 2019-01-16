defmodule BackerWeb.BackerController do
  use BackerWeb, :controller

  alias Backer.Account
  alias Backer.Account.Backer

  def index(conn, _params) do
    backers = Account.list_backers()
    render(conn, "index.html", backers: backers)
  end

  def new(conn, _params) do
    changeset = Account.change_backer(%Backer{})
    render(conn, "new.html", changeset: changeset)
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
    render(conn, "show.html", backer: backer)
  end

  def edit(conn, %{"id" => id}) do
    backer = Account.get_backer!(id)
    changeset = Account.change_backer(backer)
    render(conn, "edit.html", backer: backer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "backer" => backer_params}) do
    backer = Account.get_backer!(id)

    case Account.update_backer(backer, backer_params) do
      {:ok, backer} ->
        conn
        |> put_flash(:info, "Backer updated successfully.")
        |> redirect(to: backer_path(conn, :show, backer))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", backer: backer, changeset: changeset)
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
