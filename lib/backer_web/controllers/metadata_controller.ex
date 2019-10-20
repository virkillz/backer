defmodule BackerWeb.MetadataController do
  use BackerWeb, :controller

  alias Backer.Account
  alias Backer.Account.Metadata

  def index(conn, params) do
    metadatas = Account.list_metadatas(params)
    render(conn, "index.html", metadatas: metadatas)
  end

  def new(conn, _params) do
    changeset = Account.change_metadata(%Metadata{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"metadata" => metadata_params}) do
    case Account.create_metadata(metadata_params) do
      {:ok, metadata} ->
        conn
        |> put_flash(:info, "Metadata created successfully.")
        |> redirect(to: Router.metadata_path(conn, :show, metadata))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    metadata = Account.get_metadata!(id)
    render(conn, "show.html", metadata: metadata)
  end

  def edit(conn, %{"id" => id}) do
    metadata = Account.get_metadata!(id)
    changeset = Account.change_metadata(metadata)
    render(conn, "edit.html", metadata: metadata, changeset: changeset)
  end

  def update(conn, %{"id" => id, "metadata" => metadata_params}) do
    metadata = Account.get_metadata!(id)

    case Account.update_metadata(metadata, metadata_params) do
      {:ok, metadata} ->
        conn
        |> put_flash(:info, "Metadata updated successfully.")
        |> redirect(to: Router.metadata_path(conn, :show, metadata))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", metadata: metadata, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    metadata = Account.get_metadata!(id)
    {:ok, _metadata} = Account.delete_metadata(metadata)

    conn
    |> put_flash(:info, "Metadata deleted successfully.")
    |> redirect(to: Router.metadata_path(conn, :index))
  end
end
