defmodule Backer.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias Backer.Repo

  alias Backer.Content.Forum
  alias Backer.Account.Pledger

  @doc """
  Returns the list of forums.

  ## Examples

      iex> list_forums()
      [%Forum{}, ...]

  """
  def list_forums(params) do
    pledger = from(p in Pledger, preload: :backer)
    query = from(f in Forum, preload: [:backer, pledger: ^pledger])
    Repo.paginate(query, params)
  end

  @doc """
  Gets a single forum.

  Raises `Ecto.NoResultsError` if the Forum does not exist.

  ## Examples

      iex> get_forum!(123)
      %Forum{}

      iex> get_forum!(456)
      ** (Ecto.NoResultsError)

  """
  def get_forum!(id), do: Repo.get!(Forum, id)

  @doc """
  Creates a forum.

  ## Examples

      iex> create_forum(%{field: value})
      {:ok, %Forum{}}

      iex> create_forum(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_forum(attrs \\ %{}) do
    %Forum{}
    |> Forum.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a forum.

  ## Examples

      iex> update_forum(forum, %{field: new_value})
      {:ok, %Forum{}}

      iex> update_forum(forum, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_forum(%Forum{} = forum, attrs) do
    forum
    |> Forum.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Forum.

  ## Examples

      iex> delete_forum(forum)
      {:ok, %Forum{}}

      iex> delete_forum(forum)
      {:error, %Ecto.Changeset{}}

  """
  def delete_forum(%Forum{} = forum) do
    Repo.delete(forum)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking forum changes.

  ## Examples

      iex> change_forum(forum)
      %Ecto.Changeset{source: %Forum{}}

  """
  def change_forum(%Forum{} = forum) do
    Forum.changeset(forum, %{})
  end

  alias Backer.Content.ForumLike

  @doc """
  Returns the list of forum_like.

  ## Examples

      iex> list_forum_like()
      [%ForumLike{}, ...]

  """
  def list_forum_like do
    Repo.all(ForumLike)
  end

  @doc """
  Gets a single forum_like.

  Raises `Ecto.NoResultsError` if the Forum like does not exist.

  ## Examples

      iex> get_forum_like!(123)
      %ForumLike{}

      iex> get_forum_like!(456)
      ** (Ecto.NoResultsError)

  """
  def get_forum_like!(id), do: Repo.get!(ForumLike, id)

  @doc """
  Creates a forum_like.

  ## Examples

      iex> create_forum_like(%{field: value})
      {:ok, %ForumLike{}}

      iex> create_forum_like(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_forum_like(attrs \\ %{}) do
    %ForumLike{}
    |> ForumLike.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a forum_like.

  ## Examples

      iex> update_forum_like(forum_like, %{field: new_value})
      {:ok, %ForumLike{}}

      iex> update_forum_like(forum_like, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_forum_like(%ForumLike{} = forum_like, attrs) do
    forum_like
    |> ForumLike.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ForumLike.

  ## Examples

      iex> delete_forum_like(forum_like)
      {:ok, %ForumLike{}}

      iex> delete_forum_like(forum_like)
      {:error, %Ecto.Changeset{}}

  """
  def delete_forum_like(%ForumLike{} = forum_like) do
    Repo.delete(forum_like)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking forum_like changes.

  ## Examples

      iex> change_forum_like(forum_like)
      %Ecto.Changeset{source: %ForumLike{}}

  """
  def change_forum_like(%ForumLike{} = forum_like) do
    ForumLike.changeset(forum_like, %{})
  end

  alias Backer.Content.ForumComment

  @doc """
  Returns the list of fcomments.

  ## Examples

      iex> list_fcomments()
      [%ForumComment{}, ...]

  """
  def list_fcomments do
    Repo.all(ForumComment)
  end

  def list_fcomments(%{"forum_id" => id}) do
    query = from(f in ForumComment, where: f.forum_id == ^id)
    Repo.all(query)
  end

  @doc """
  Gets a single forum_comment.

  Raises `Ecto.NoResultsError` if the Forum comment does not exist.

  ## Examples

      iex> get_forum_comment!(123)
      %ForumComment{}

      iex> get_forum_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_forum_comment!(id), do: Repo.get!(ForumComment, id)

  @doc """
  Creates a forum_comment.

  ## Examples

      iex> create_forum_comment(%{field: value})
      {:ok, %ForumComment{}}

      iex> create_forum_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_forum_comment(attrs \\ %{}) do
    %ForumComment{}
    |> ForumComment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a forum_comment.

  ## Examples

      iex> update_forum_comment(forum_comment, %{field: new_value})
      {:ok, %ForumComment{}}

      iex> update_forum_comment(forum_comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_forum_comment(%ForumComment{} = forum_comment, attrs) do
    forum_comment
    |> ForumComment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ForumComment.

  ## Examples

      iex> delete_forum_comment(forum_comment)
      {:ok, %ForumComment{}}

      iex> delete_forum_comment(forum_comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_forum_comment(%ForumComment{} = forum_comment) do
    Repo.delete(forum_comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking forum_comment changes.

  ## Examples

      iex> change_forum_comment(forum_comment)
      %Ecto.Changeset{source: %ForumComment{}}

  """
  def change_forum_comment(%ForumComment{} = forum_comment) do
    ForumComment.changeset(forum_comment, %{})
  end

  alias Backer.Content.FCommentLike

  @doc """
  Returns the list of fcomment_like.

  ## Examples

      iex> list_fcomment_like()
      [%FCommentLike{}, ...]

  """
  def list_fcomment_like do
    Repo.all(FCommentLike)
  end

  @doc """
  Gets a single f_comment_like.

  Raises `Ecto.NoResultsError` if the F comment like does not exist.

  ## Examples

      iex> get_f_comment_like!(123)
      %FCommentLike{}

      iex> get_f_comment_like!(456)
      ** (Ecto.NoResultsError)

  """
  def get_f_comment_like!(id), do: Repo.get!(FCommentLike, id)

  @doc """
  Creates a f_comment_like.

  ## Examples

      iex> create_f_comment_like(%{field: value})
      {:ok, %FCommentLike{}}

      iex> create_f_comment_like(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_f_comment_like(attrs \\ %{}) do
    %FCommentLike{}
    |> FCommentLike.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a f_comment_like.

  ## Examples

      iex> update_f_comment_like(f_comment_like, %{field: new_value})
      {:ok, %FCommentLike{}}

      iex> update_f_comment_like(f_comment_like, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_f_comment_like(%FCommentLike{} = f_comment_like, attrs) do
    f_comment_like
    |> FCommentLike.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a FCommentLike.

  ## Examples

      iex> delete_f_comment_like(f_comment_like)
      {:ok, %FCommentLike{}}

      iex> delete_f_comment_like(f_comment_like)
      {:error, %Ecto.Changeset{}}

  """
  def delete_f_comment_like(%FCommentLike{} = f_comment_like) do
    Repo.delete(f_comment_like)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking f_comment_like changes.

  ## Examples

      iex> change_f_comment_like(f_comment_like)
      %Ecto.Changeset{source: %FCommentLike{}}

  """
  def change_f_comment_like(%FCommentLike{} = f_comment_like) do
    FCommentLike.changeset(f_comment_like, %{})
  end

  alias Backer.Content.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts(params) do
    # Repo.all(Post)
    Post |> Repo.paginate(params)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    Repo.get!(Post, id)
    |> Repo.preload(:pcomment)
    |> IO.inspect()
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  alias Backer.Content.PostLike

  @doc """
  Returns the list of post_likes.

  ## Examples

      iex> list_post_likes()
      [%PostLike{}, ...]

  """
  def list_post_likes do
    Repo.all(PostLike)
  end

  @doc """
  Gets a single post_like.

  Raises `Ecto.NoResultsError` if the Post like does not exist.

  ## Examples

      iex> get_post_like!(123)
      %PostLike{}

      iex> get_post_like!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post_like!(id), do: Repo.get!(PostLike, id)

  @doc """
  Creates a post_like.

  ## Examples

      iex> create_post_like(%{field: value})
      {:ok, %PostLike{}}

      iex> create_post_like(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post_like(attrs \\ %{}) do
    %PostLike{}
    |> PostLike.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post_like.

  ## Examples

      iex> update_post_like(post_like, %{field: new_value})
      {:ok, %PostLike{}}

      iex> update_post_like(post_like, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post_like(%PostLike{} = post_like, attrs) do
    post_like
    |> PostLike.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PostLike.

  ## Examples

      iex> delete_post_like(post_like)
      {:ok, %PostLike{}}

      iex> delete_post_like(post_like)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post_like(%PostLike{} = post_like) do
    Repo.delete(post_like)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post_like changes.

  ## Examples

      iex> change_post_like(post_like)
      %Ecto.Changeset{source: %PostLike{}}

  """
  def change_post_like(%PostLike{} = post_like) do
    PostLike.changeset(post_like, %{})
  end

  alias Backer.Content.PostComment

  @doc """
  Returns the list of pcomments.

  ## Examples

      iex> list_pcomments()
      [%PostComment{}, ...]

  """
  def list_pcomments do
    Repo.all(PostComment)
  end

  def list_pcomments(%{"post_id" => post_id}) do
    query = from(p in PostComment, where: p.post_id == ^post_id)

    Repo.all(query)
  end

  @doc """
  Gets a single post_comment.

  Raises `Ecto.NoResultsError` if the Post comment does not exist.

  ## Examples

      iex> get_post_comment!(123)
      %PostComment{}

      iex> get_post_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post_comment!(id), do: Repo.get!(PostComment, id)

  @doc """
  Creates a post_comment.

  ## Examples

      iex> create_post_comment(%{field: value})
      {:ok, %PostComment{}}

      iex> create_post_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post_comment(attrs \\ %{}) do
    %PostComment{}
    |> PostComment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post_comment.

  ## Examples

      iex> update_post_comment(post_comment, %{field: new_value})
      {:ok, %PostComment{}}

      iex> update_post_comment(post_comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post_comment(%PostComment{} = post_comment, attrs) do
    post_comment
    |> PostComment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PostComment.

  ## Examples

      iex> delete_post_comment(post_comment)
      {:ok, %PostComment{}}

      iex> delete_post_comment(post_comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post_comment(%PostComment{} = post_comment) do
    Repo.delete(post_comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post_comment changes.

  ## Examples

      iex> change_post_comment(post_comment)
      %Ecto.Changeset{source: %PostComment{}}

  """
  def change_post_comment(%PostComment{} = post_comment) do
    PostComment.changeset(post_comment, %{})
  end

  alias Backer.Content.PCommentLike

  @doc """
  Returns the list of pcomment_likes.

  ## Examples

      iex> list_pcomment_likes()
      [%PCommentLike{}, ...]

  """
  def list_pcomment_likes do
    Repo.all(PCommentLike)
  end

  @doc """
  Gets a single p_comment_like.

  Raises `Ecto.NoResultsError` if the P comment like does not exist.

  ## Examples

      iex> get_p_comment_like!(123)
      %PCommentLike{}

      iex> get_p_comment_like!(456)
      ** (Ecto.NoResultsError)

  """
  def get_p_comment_like!(id), do: Repo.get!(PCommentLike, id)

  @doc """
  Creates a p_comment_like.

  ## Examples

      iex> create_p_comment_like(%{field: value})
      {:ok, %PCommentLike{}}

      iex> create_p_comment_like(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_p_comment_like(attrs \\ %{}) do
    %PCommentLike{}
    |> PCommentLike.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a p_comment_like.

  ## Examples

      iex> update_p_comment_like(p_comment_like, %{field: new_value})
      {:ok, %PCommentLike{}}

      iex> update_p_comment_like(p_comment_like, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_p_comment_like(%PCommentLike{} = p_comment_like, attrs) do
    p_comment_like
    |> PCommentLike.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PCommentLike.

  ## Examples

      iex> delete_p_comment_like(p_comment_like)
      {:ok, %PCommentLike{}}

      iex> delete_p_comment_like(p_comment_like)
      {:error, %Ecto.Changeset{}}

  """
  def delete_p_comment_like(%PCommentLike{} = p_comment_like) do
    Repo.delete(p_comment_like)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking p_comment_like changes.

  ## Examples

      iex> change_p_comment_like(p_comment_like)
      %Ecto.Changeset{source: %PCommentLike{}}

  """
  def change_p_comment_like(%PCommentLike{} = p_comment_like) do
    PCommentLike.changeset(p_comment_like, %{})
  end
end
