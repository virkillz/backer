defmodule BackerWeb.BackingAggregateController do
  use BackerWeb, :controller

  alias Backer.Aggregate
  alias Backer.Aggregate.BackingAggregate

  def index(conn, _params) do
    backingaggregates = Aggregate.list_backingaggregates()
    render(conn, "index.html", backingaggregates: backingaggregates)
  end

  def new(conn, _params) do
    changeset = Aggregate.change_backing_aggregate(%BackingAggregate{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"backing_aggregate" => backing_aggregate_params}) do
    case Aggregate.create_backing_aggregate(backing_aggregate_params) do
      {:ok, backing_aggregate} ->
        conn
        |> put_flash(:info, "Backing aggregate created successfully.")
        |> redirect(to: Router.backing_aggregate_path(conn, :show, backing_aggregate))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    backing_aggregate = Aggregate.get_backing_aggregate!(id)
    render(conn, "show.html", backing_aggregate: backing_aggregate)
  end

  def edit(conn, %{"id" => id}) do
    backing_aggregate = Aggregate.get_backing_aggregate!(id)
    changeset = Aggregate.change_backing_aggregate(backing_aggregate)
    render(conn, "edit.html", backing_aggregate: backing_aggregate, changeset: changeset)
  end

  def update(conn, %{"id" => id, "backing_aggregate" => backing_aggregate_params}) do
    backing_aggregate = Aggregate.get_backing_aggregate!(id)

    case Aggregate.update_backing_aggregate(backing_aggregate, backing_aggregate_params) do
      {:ok, backing_aggregate} ->
        conn
        |> put_flash(:info, "Backing aggregate updated successfully.")
        |> redirect(to: Router.backing_aggregate_path(conn, :show, backing_aggregate))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", backing_aggregate: backing_aggregate, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    backing_aggregate = Aggregate.get_backing_aggregate!(id)
    {:ok, _backing_aggregate} = Aggregate.delete_backing_aggregate(backing_aggregate)

    conn
    |> put_flash(:info, "Backing aggregate deleted successfully.")
    |> redirect(to: Router.backing_aggregate_path(conn, :index))
  end
end
