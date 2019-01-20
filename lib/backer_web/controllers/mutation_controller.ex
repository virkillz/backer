defmodule BackerWeb.MutationController do
  use BackerWeb, :controller

  alias Backer.Finance
  alias Backer.Finance.Mutation

  def index(conn, _params) do
    mutations = Finance.list_mutations()
    render(conn, "index.html", mutations: mutations)
  end

  def new(conn, _params) do
    changeset = Finance.change_mutation(%Mutation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"mutation" => mutation_params}) do
    case Finance.create_mutation(mutation_params) do
      {:ok, mutation} ->
        conn
        |> put_flash(:info, "Mutation created successfully.")
        |> redirect(to: mutation_path(conn, :show, mutation))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    mutation = Finance.get_mutation!(id)
    render(conn, "show.html", mutation: mutation)
  end

  def edit(conn, %{"id" => id}) do
    mutation = Finance.get_mutation!(id)
    changeset = Finance.change_mutation(mutation)
    render(conn, "edit.html", mutation: mutation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "mutation" => mutation_params}) do
    mutation = Finance.get_mutation!(id)

    case Finance.update_mutation(mutation, mutation_params) do
      {:ok, mutation} ->
        conn
        |> put_flash(:info, "Mutation updated successfully.")
        |> redirect(to: mutation_path(conn, :show, mutation))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", mutation: mutation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    mutation = Finance.get_mutation!(id)
    {:ok, _mutation} = Finance.delete_mutation(mutation)

    conn
    |> put_flash(:info, "Mutation deleted successfully.")
    |> redirect(to: mutation_path(conn, :index))
  end
end
