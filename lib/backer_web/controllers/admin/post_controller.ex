defmodule BackerWeb.PostController do
  use BackerWeb, :controller

  alias Backer.Content
  alias Backer.Account
  alias Backer.Constant
  alias Backer.Content.Post

  def index(conn, params) do
    posts = Content.list_posts(params)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    donees = Account.list_donees()
    tiers = Constant.standard_tier()
    changeset = Content.change_post(%Post{})
    render(conn, "new.html", changeset: changeset, donees: donees, tiers: tiers)
  end

  def create(conn, %{"post" => post_params}) do
    case Content.create_post(post_params |> convert_featured_atom) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Router.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        donees = Account.list_donees()
        tiers = Constant.standard_tier()
        render(conn, "new.html", changeset: changeset, donees: donees, tiers: tiers)
    end
  end

  defp convert_featured_atom(%{"featured_select" => ""} = attr) do
    attr
  end

  defp convert_featured_atom(%{"featured_select" => "image"} = attr) do
    if attr["featured_content"] == "" do
      attr
    else
      attr
      |> Map.put("featured_image", attr["featured_content"])
      |> Map.put("featured_video", "")
      |> Map.put("featured_link", "")
    end
  end

  defp convert_featured_atom(%{"featured_select" => "video"} = attr) do
    if attr["featured_content"] == "" do
      attr
    else
      attr
      |> Map.put("featured_video", attr["featured_content"])
      |> Map.put("featured_link", "")
      |> Map.put("featured_image", "")
    end
  end

  defp convert_featured_atom(%{"featured_select" => "link"} = attr) do
    if attr["featured_content"] == "" do
      attr
    else
      attr
      |> Map.put("featured_link", attr["featured_content"])
      |> Map.put("featured_video", "")
      |> Map.put("featured_image", "")
    end
  end

  def show(conn, %{"id" => id}) do
    pcomments = Content.list_pcomments(%{"post_id" => id}) |> IO.inspect()
    post = Content.get_post!(id)
    render(conn, "show.html", post: post, pcomments: pcomments)
  end

  def edit(conn, %{"id" => id}) do
    post = Content.get_post!(id)
    donees = Account.list_donees()
    changeset = Content.change_post(post)
    tiers = Constant.standard_tier()
    render(conn, "edit.html", post: post, changeset: changeset, donees: donees, tiers: tiers)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Content.get_post!(id)

    case Content.update_post(post, post_params |> convert_featured_atom) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Router.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        donees = Account.list_donees()
        tiers = Constant.standard_tier()

        render(conn, "edit.html",
          post: post,
          changeset: changeset,
          donees: donees,
          tiers: tiers
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Content.get_post!(id)
    {:ok, _post} = Content.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Router.post_path(conn, :index))
  end
end
