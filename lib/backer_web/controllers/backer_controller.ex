defmodule BackerWeb.BackerController do
  use BackerWeb, :controller

  alias Backer.Finance
  alias Backer.Account
  alias Backer.Constant  
  alias Backer.Account.Backer

  def index(conn, params) do
    backers = Account.list_backers(params)
    render(conn, "index.html", backers: backers)
  end

  def new(conn, _params) do
    id_types = Constant.accepted_id_kyc
    changeset = Account.change_backer(%Backer{})
    render(conn, "new.html", changeset: changeset, id_types: id_types)
  end

  def create(conn, %{"backer" => backer_params}) do
    IO.inspect("SAMPAI SINI============")
    case Account.create_backer(backer_params) |> IO.inspect do
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
    id_types = Constant.accepted_id_kyc
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
        id_types = Constant.accepted_id_kyc
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
