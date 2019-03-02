defmodule Backer.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias Backer.Repo

  alias Backer.Content.Forum
  alias Backer.Finance.Donation
  alias Backer.Account.Pledger
  alias Backer.Account.Backer, as: Backerz
  alias Backer.Content.PostComment
  alias Backer.Content.PostLike  
  alias Backer.Content.PCommentLike  

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
  def list_posts(%{"pledger_id" => pledger_id}) do
    # Repo.all(Post)

    query = from(p in Post, where: p.pledger_id == ^pledger_id)

    Repo.all(query)
  end

  def list_posts(params) do
    # Repo.all(Post)
    Post |> Repo.paginate(params)
  end

  def timeline(%{"backer_id" => backer_id}) do
    {year, month, _day} = Date.utc_today() |> Date.to_erl()

    # get all pledger currently backed.
    query =
      from(p in Donation,
        where:
          p.backer_id == ^backer_id and p.is_executed == true and p.month == ^month and
            p.year == ^year
      )

    # get post from that pledger
    query2 =
      from(donation in query,
        join: post in Post,
        join: pledger in Pledger,
        join: backer in Backerz,
        on: pledger.backer_id == backer.id,
        on: post.pledger_id == pledger.id,
        where: post.pledger_id == donation.pledger_id,
        select: %{
          id: post.id,
          title: post.title,
          avatar: backer.avatar,
          content: post.content,
          display_name: backer.display_name,
          type: post.type,
          image: post.featured_image,
          video: post.featured_video,
          link: post.featured_link,
          inserted_at: post.inserted_at,
          comment_count: post.comment_count,
          like_count: post.like_count
        },
        order_by: [desc: post.id]
      )

    pledger = Repo.all(query)
    post = Repo.all(query2)

    {pledger, post}
  end

  def timeline(backer_id) do
    {year, month, _day} = Date.utc_today() |> Date.to_erl()

    # get all pledger currently backed.
    query =
      from(p in Donation,
        where:
          p.backer_id == ^backer_id and p.is_executed == true and p.month == ^month and
            p.year == ^year
      )

    query2 =
      from(p in PostComment,
        where: p.is_featured == true,
        join: backer in Backerz,
        on: p.backer_id == backer.id,
        order_by: p.id,
        select: %{
          id: p.id,
          content: p.content,
          avatar: backer.avatar,
          inserted_at: p.inserted_at,
          display_name: backer.display_name,
          username: backer.username
        }
      )

    query3 = from(p in Post, join: s in subquery(query), on: s.pledger_id == p.pledger_id)

    query4 =
      from(p in query3,
        preload: [pcomment: ^query2, pledger: [:backer]],
        order_by: [desc: p.id]
      )

    donation = Repo.all(query)
    post = Repo.all(query4)

    {donation, post}
  end

  def timeline_pledger(id) do
    query =
      from(post in Post,
        preload: [pcomment: [:backer]],
        where: post.pledger_id == ^id,
        order_by: [desc: post.id]
      )

    Repo.all(query)
  end

  def get_post(%{"id" => id, "backer_id" => backer_id}) do
    query =
      from(post in Post,
        where: post.id == ^id,
        join: pledger in Pledger,
        join: backer in Backerz,
        on: pledger.backer_id == backer.id,
        on: post.pledger_id == pledger.id,
        select: %{
          id: post.id,
          title: post.title,
          min_tier: post.min_tier,
          avatar: backer.avatar,
          username: backer.username,
          type: post.type,
          image: post.featured_image,
          video: post.featured_video,
          link: post.featured_link,
          content: post.content,
          like_count: post.like_count,
          comment_count: post.comment_count,
          display_name: backer.display_name,
          inserted_at: post.inserted_at
        }
      )

    query_like_post = 
      from like in PostLike,
        where: like.backer_id == ^backer_id and like.post_id == ^id

    post_like? = if query_like_post |> first |> Repo.one == nil, do: false, else: true

    query_comment =
      from(comment in PostComment,
        where: comment.post_id == ^id,
        join: backer in Backerz,
        on: comment.backer_id == backer.id,
        order_by: comment.id,
        select: %{
          id: comment.id,
          content: comment.content,
          avatar: backer.avatar,
          like_count: comment.like_count,
          username: backer.username,
          inserted_at: comment.inserted_at,
          display_name: backer.display_name,
          is_featured: comment.is_featured
        }
      )

    post = Repo.one(query) |> Map.put(:is_liked, post_like?)
    comment = Repo.all(query_comment)

    {post, comment}
  end


  def is_post_liked?(post_id, backer_id) do
    query_like_post = 
      from like in PostLike,
        where: like.backer_id == ^backer_id and like.post_id == ^post_id
    post_like? = if query_like_post |> first |> Repo.one == nil, do: false, else: true    
  end


  def list_liked_comments(comments, backer_id) do

    query = PCommentLike 
    |> where([p], p.pcomment_id in ^comments) 
    |> where([p], p.backer_id == ^backer_id) 
    |> select([p], p.pcomment_id)
    |> Repo.all 

  end



  def get_post(%{"id" => id}) do
    query =
      from(post in Post,
        where: post.id == ^id,
        join: pledger in Pledger,
        join: backer in Backerz,
        on: pledger.backer_id == backer.id,
        on: post.pledger_id == pledger.id,
        select: %{
          id: post.id,
          title: post.title,
          min_tier: post.min_tier,
          avatar: backer.avatar,
          username: backer.username,
          type: post.type,
          image: post.featured_image,
          video: post.featured_video,
          link: post.featured_link,
          content: post.content,
          like_count: post.like_count,
          comment_count: post.comment_count,
          display_name: backer.display_name,
          inserted_at: post.inserted_at
        }
      )

    query_comment =
      from(comment in PostComment,
        where: comment.post_id == ^id,
        join: backer in Backerz,
        on: comment.backer_id == backer.id,
        order_by: comment.id,
        select: %{
          id: comment.id,
          content: comment.content,
          avatar: backer.avatar,
          username: backer.username,
          like_count: comment.like_count,
          inserted_at: comment.inserted_at,
          display_name: backer.display_name,
          is_featured: comment.is_featured
        }
      )

    post = Repo.one(query)
    comment = Repo.all(query_comment)

    {post, comment}
  end


  def get_post!(id) do
    Repo.get!(Post, id)
    |> Repo.preload(:pcomment)
  end

  def get_post_simple(pledger_id, id) do
    query = from(p in Post, where: p.id == ^id and p.pledger_id == ^pledger_id)

    Repo.one(query)
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

  def list_post_from_array(list) do
    posts = Post |> where([p], p.id in ^list) |> Repo.all()
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

  # def create_post_like_multi(attrs \\ %{}) do
  #   like_changeset = PostLike.changeset(%PostLike{}, attrs)

  #   Ecto.Multi.new()
  #   |> Ecto.Multi.insert(:like, like_changeset)
  #   |> Ecto.Multi.run(:post, fn repo, %{like: like} ->
  #     post = get_post!(like.post_id)

  #     attrs = %{"like_count" => post.like_count + 1}
  #     changeset = Post.changeset(post, attrs)
  #     repo.update(changeset)
  #   end)
  #   |> Repo.transaction()
  # end


  def like_post_comment(%{"pcomment_id" => pcomment_id, "backer_id" => backer_id}) do
    query = 
      from p in PCommentLike,
      where: p.pcomment_id == ^pcomment_id and p.backer_id == ^backer_id

    post_comment_like = Repo.one(query)

    if post_comment_like == nil do

    attrs = %{"pcomment_id" => pcomment_id, "backer_id" => backer_id}
    post_comment_like_changeset = PCommentLike.changeset(%PCommentLike{}, attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:comment_like, post_comment_like_changeset)
    |> Ecto.Multi.run(:post_comment, fn repo, %{comment_like: comment_like} ->
      comment = get_post_comment!(comment_like.pcomment_id)

      attrs = %{"like_count" => comment.like_count + 1}
      changeset = PostComment.changeset(comment, attrs)
      repo.update(changeset)
    end)
    |> Repo.transaction()

    else

      Ecto.Multi.new()
      |> Ecto.Multi.delete(:comment_like, post_comment_like)
      |> Ecto.Multi.run(:post_comment, fn repo, %{comment_like: _post} ->
        post_comment = Repo.get!(PostComment, pcomment_id)

        attrs = %{"like_count" => post_comment.like_count - 1}
        changeset = PostComment.changeset(post_comment, attrs)
        repo.update(changeset)
      end)
      |> Repo.transaction()

    end

  end


  def like_post(%{"post_id"=> post_id, "backer_id"=> backer_id} = attrs) do
    
    query = 
      from p in PostLike,
      where: p.post_id == ^post_id and p.backer_id == ^backer_id

    post_like = Repo.one(query)

    if post_like == nil do
      # if not exist, like post!
      changeset = %PostLike{} |> PostLike.changeset(attrs)
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:like, changeset)
      |> Ecto.Multi.run(:post, fn repo, %{like: like} ->
        post = get_post!(like.post_id)

        attrs2 = %{"like_count" => post.like_count + 1}
        changeset = Post.changeset(post, attrs2)
        repo.update(changeset)
      end)
      |> Repo.transaction()      
    else
      # dislike post
      Ecto.Multi.new()
      |> Ecto.Multi.delete(:like, post_like)
      |> Ecto.Multi.run(:post, fn repo, %{like: _like} ->
        post = Repo.get!(Post, post_id)

        attrs2 = %{"like_count" => post.like_count - 1}
        changeset = Post.changeset(post, attrs2)
        repo.update(changeset)
      end)
      |> Repo.transaction()
    end

  end






  # def like_post(attrs \\ %{}) do
  #   like_changeset = PostLike.changeset(%PostLike{}, attrs)

  #   Ecto.Multi.new()
  #   |> Ecto.Multi.insert(:like, like_changeset)
  #   |> Ecto.Multi.run(:post, fn repo, %{like: like} ->
  #     post = get_post!(like.post_id)

  #     attrs = %{"like_count" => post.like_count + 1}
  #     changeset = Post.changeset(post, attrs)
  #     repo.update(changeset)
  #   end)
  #   |> Repo.transaction()
  # end  


  # def dislike_post(post_id, backer_id) do

  #   query = 
  #     from p in PostLike,
  #     where: p.post_id == ^post_id and p.backer_id == ^backer_id

  #   post_comment = Repo.one(query)

  #   Ecto.Multi.new()
  #   |> Ecto.Multi.delete(:post_comment, post_comment)
  #   |> Ecto.Multi.run(:post, fn repo, %{post_comment: _post} ->
  #     post = Repo.get!(Post, post_id)

  #     attrs = %{"like_count" => post.like_count - 1}
  #     changeset = Post.changeset(post, attrs)
  #     repo.update(changeset)
  #   end)
  #   |> Repo.transaction()
  # end    

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
  # def create_post_comment(attrs \\ %{}) do
  #   %PostComment{}
  #   |> PostComment.changeset(attrs)
  #   |> Repo.insert()
  # end

  def create_post_comment_multi(attrs \\ %{}) do
    comment_changeset = PostComment.changeset(%PostComment{}, attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:comment, comment_changeset)
    |> Ecto.Multi.run(:post, fn repo, %{comment: comment} ->
      post = get_post!(comment.post_id)

      count = comment_count(post.id)
      # attrs = %{"comment_count" => count.count}

      attrs = %{"comment_count" => post.comment_count + 1}

      changeset = Post.changeset(post, attrs)
      repo.update(changeset)
    end)
    |> Ecto.Multi.run(:update_featured, fn repo, %{comment: comment} ->
      update_previous_comment(repo, comment.post_id)
    end)
    |> Repo.transaction()
  end




  defp update_previous_comment(repo, post_id) do
    older_comment = get_previous_comment(post_id, 1)

    case older_comment do
      :zero ->
        {:ok, "lanjut"}

      [comment] ->
        attrs = %{"is_featured" => false}
        changeset = PostComment.changeset(comment, attrs)
        repo.update(changeset)
    end
  end

  defp get_previous_comment(post_id, nth) do
    query =
      from(c in PostComment,
        where: c.post_id == ^post_id,
        order_by: [desc: c.id],
        limit: ^nth + 1
      )

    result = Repo.all(query)

    case Enum.count(result) do
      0 -> :zero
      1 -> :zero
      # give the last
      _other -> Enum.take(result, -1)
    end
  end

  def comment_count(id) do
    query =
      from(c in PostComment,
        where: c.post_id == ^id,
        select: %{count: count(c.id)}
      )

    Repo.one(query)
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
