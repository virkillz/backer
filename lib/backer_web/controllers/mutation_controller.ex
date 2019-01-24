defmodule BackerWeb.MutationController do
  use BackerWeb, :controller

  alias Backer.Finance
  # alias Backer.Finance.Mutation

  def index(conn, _params) do
    mutations = Finance.list_mutations()
    render(conn, "index.html", mutations: mutations)
  end


  def show(conn, %{"id" => id}) do
    mutation = Finance.get_mutation!(id)
    render(conn, "show.html", mutation: mutation)
  end

  def delete(conn, %{"id" => id}) do
    mutation = Finance.get_mutation!(id)
    {:ok, _mutation} = Finance.delete_mutation(mutation)

    conn
    |> put_flash(:info, "Mutation deleted successfully.")
    |> redirect(to: mutation_path(conn, :index))
  end
end
