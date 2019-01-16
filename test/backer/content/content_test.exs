defmodule Backer.ContentTest do
  use Backer.DataCase

  alias Backer.Content

  describe "forums" do
    alias Backer.Content.Forum

    @valid_attrs %{
      content: "some content",
      is_visible: true,
      like_count: 42,
      status: "some status",
      title: "some title"
    }
    @update_attrs %{
      content: "some updated content",
      is_visible: false,
      like_count: 43,
      status: "some updated status",
      title: "some updated title"
    }
    @invalid_attrs %{content: nil, is_visible: nil, like_count: nil, status: nil, title: nil}

    def forum_fixture(attrs \\ %{}) do
      {:ok, forum} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_forum()

      forum
    end

    test "list_forums/0 returns all forums" do
      forum = forum_fixture()
      assert Content.list_forums() == [forum]
    end

    test "get_forum!/1 returns the forum with given id" do
      forum = forum_fixture()
      assert Content.get_forum!(forum.id) == forum
    end

    test "create_forum/1 with valid data creates a forum" do
      assert {:ok, %Forum{} = forum} = Content.create_forum(@valid_attrs)
      assert forum.content == "some content"
      assert forum.is_visible == true
      assert forum.like_count == 42
      assert forum.status == "some status"
      assert forum.title == "some title"
    end

    test "create_forum/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_forum(@invalid_attrs)
    end

    test "update_forum/2 with valid data updates the forum" do
      forum = forum_fixture()
      assert {:ok, forum} = Content.update_forum(forum, @update_attrs)
      assert %Forum{} = forum
      assert forum.content == "some updated content"
      assert forum.is_visible == false
      assert forum.like_count == 43
      assert forum.status == "some updated status"
      assert forum.title == "some updated title"
    end

    test "update_forum/2 with invalid data returns error changeset" do
      forum = forum_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_forum(forum, @invalid_attrs)
      assert forum == Content.get_forum!(forum.id)
    end

    test "delete_forum/1 deletes the forum" do
      forum = forum_fixture()
      assert {:ok, %Forum{}} = Content.delete_forum(forum)
      assert_raise Ecto.NoResultsError, fn -> Content.get_forum!(forum.id) end
    end

    test "change_forum/1 returns a forum changeset" do
      forum = forum_fixture()
      assert %Ecto.Changeset{} = Content.change_forum(forum)
    end
  end

  describe "forum_like" do
    alias Backer.Content.ForumLike

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def forum_like_fixture(attrs \\ %{}) do
      {:ok, forum_like} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_forum_like()

      forum_like
    end

    test "list_forum_like/0 returns all forum_like" do
      forum_like = forum_like_fixture()
      assert Content.list_forum_like() == [forum_like]
    end

    test "get_forum_like!/1 returns the forum_like with given id" do
      forum_like = forum_like_fixture()
      assert Content.get_forum_like!(forum_like.id) == forum_like
    end

    test "create_forum_like/1 with valid data creates a forum_like" do
      assert {:ok, %ForumLike{} = forum_like} = Content.create_forum_like(@valid_attrs)
    end

    test "create_forum_like/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_forum_like(@invalid_attrs)
    end

    test "update_forum_like/2 with valid data updates the forum_like" do
      forum_like = forum_like_fixture()
      assert {:ok, forum_like} = Content.update_forum_like(forum_like, @update_attrs)
      assert %ForumLike{} = forum_like
    end

    test "update_forum_like/2 with invalid data returns error changeset" do
      forum_like = forum_like_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_forum_like(forum_like, @invalid_attrs)
      assert forum_like == Content.get_forum_like!(forum_like.id)
    end

    test "delete_forum_like/1 deletes the forum_like" do
      forum_like = forum_like_fixture()
      assert {:ok, %ForumLike{}} = Content.delete_forum_like(forum_like)
      assert_raise Ecto.NoResultsError, fn -> Content.get_forum_like!(forum_like.id) end
    end

    test "change_forum_like/1 returns a forum_like changeset" do
      forum_like = forum_like_fixture()
      assert %Ecto.Changeset{} = Content.change_forum_like(forum_like)
    end
  end

  describe "fcomments" do
    alias Backer.Content.ForumComment

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def forum_comment_fixture(attrs \\ %{}) do
      {:ok, forum_comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_forum_comment()

      forum_comment
    end

    test "list_fcomments/0 returns all fcomments" do
      forum_comment = forum_comment_fixture()
      assert Content.list_fcomments() == [forum_comment]
    end

    test "get_forum_comment!/1 returns the forum_comment with given id" do
      forum_comment = forum_comment_fixture()
      assert Content.get_forum_comment!(forum_comment.id) == forum_comment
    end

    test "create_forum_comment/1 with valid data creates a forum_comment" do
      assert {:ok, %ForumComment{} = forum_comment} = Content.create_forum_comment(@valid_attrs)
      assert forum_comment.content == "some content"
    end

    test "create_forum_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_forum_comment(@invalid_attrs)
    end

    test "update_forum_comment/2 with valid data updates the forum_comment" do
      forum_comment = forum_comment_fixture()
      assert {:ok, forum_comment} = Content.update_forum_comment(forum_comment, @update_attrs)
      assert %ForumComment{} = forum_comment
      assert forum_comment.content == "some updated content"
    end

    test "update_forum_comment/2 with invalid data returns error changeset" do
      forum_comment = forum_comment_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Content.update_forum_comment(forum_comment, @invalid_attrs)

      assert forum_comment == Content.get_forum_comment!(forum_comment.id)
    end

    test "delete_forum_comment/1 deletes the forum_comment" do
      forum_comment = forum_comment_fixture()
      assert {:ok, %ForumComment{}} = Content.delete_forum_comment(forum_comment)
      assert_raise Ecto.NoResultsError, fn -> Content.get_forum_comment!(forum_comment.id) end
    end

    test "change_forum_comment/1 returns a forum_comment changeset" do
      forum_comment = forum_comment_fixture()
      assert %Ecto.Changeset{} = Content.change_forum_comment(forum_comment)
    end
  end

  describe "fcomment_like" do
    alias Backer.Content.FCommentLike

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def f_comment_like_fixture(attrs \\ %{}) do
      {:ok, f_comment_like} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_f_comment_like()

      f_comment_like
    end

    test "list_fcomment_like/0 returns all fcomment_like" do
      f_comment_like = f_comment_like_fixture()
      assert Content.list_fcomment_like() == [f_comment_like]
    end

    test "get_f_comment_like!/1 returns the f_comment_like with given id" do
      f_comment_like = f_comment_like_fixture()
      assert Content.get_f_comment_like!(f_comment_like.id) == f_comment_like
    end

    test "create_f_comment_like/1 with valid data creates a f_comment_like" do
      assert {:ok, %FCommentLike{} = f_comment_like} = Content.create_f_comment_like(@valid_attrs)
    end

    test "create_f_comment_like/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_f_comment_like(@invalid_attrs)
    end

    test "update_f_comment_like/2 with valid data updates the f_comment_like" do
      f_comment_like = f_comment_like_fixture()
      assert {:ok, f_comment_like} = Content.update_f_comment_like(f_comment_like, @update_attrs)
      assert %FCommentLike{} = f_comment_like
    end

    test "update_f_comment_like/2 with invalid data returns error changeset" do
      f_comment_like = f_comment_like_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Content.update_f_comment_like(f_comment_like, @invalid_attrs)

      assert f_comment_like == Content.get_f_comment_like!(f_comment_like.id)
    end

    test "delete_f_comment_like/1 deletes the f_comment_like" do
      f_comment_like = f_comment_like_fixture()
      assert {:ok, %FCommentLike{}} = Content.delete_f_comment_like(f_comment_like)
      assert_raise Ecto.NoResultsError, fn -> Content.get_f_comment_like!(f_comment_like.id) end
    end

    test "change_f_comment_like/1 returns a f_comment_like changeset" do
      f_comment_like = f_comment_like_fixture()
      assert %Ecto.Changeset{} = Content.change_f_comment_like(f_comment_like)
    end
  end

  describe "posts" do
    alias Backer.Content.Post

    @valid_attrs %{
      content: "some content",
      featured_image: "some featured_image",
      featured_link: "some featured_link",
      featured_video: "some featured_video",
      like_count: 42,
      min_tier: 42,
      title: "some title"
    }
    @update_attrs %{
      content: "some updated content",
      featured_image: "some updated featured_image",
      featured_link: "some updated featured_link",
      featured_video: "some updated featured_video",
      like_count: 43,
      min_tier: 43,
      title: "some updated title"
    }
    @invalid_attrs %{
      content: nil,
      featured_image: nil,
      featured_link: nil,
      featured_video: nil,
      like_count: nil,
      min_tier: nil,
      title: nil
    }

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Content.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Content.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Content.create_post(@valid_attrs)
      assert post.content == "some content"
      assert post.featured_image == "some featured_image"
      assert post.featured_link == "some featured_link"
      assert post.featured_video == "some featured_video"
      assert post.like_count == 42
      assert post.min_tier == 42
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = Content.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.content == "some updated content"
      assert post.featured_image == "some updated featured_image"
      assert post.featured_link == "some updated featured_link"
      assert post.featured_video == "some updated featured_video"
      assert post.like_count == 43
      assert post.min_tier == 43
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_post(post, @invalid_attrs)
      assert post == Content.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Content.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Content.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Content.change_post(post)
    end
  end

  describe "post_likes" do
    alias Backer.Content.PostLike

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def post_like_fixture(attrs \\ %{}) do
      {:ok, post_like} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_post_like()

      post_like
    end

    test "list_post_likes/0 returns all post_likes" do
      post_like = post_like_fixture()
      assert Content.list_post_likes() == [post_like]
    end

    test "get_post_like!/1 returns the post_like with given id" do
      post_like = post_like_fixture()
      assert Content.get_post_like!(post_like.id) == post_like
    end

    test "create_post_like/1 with valid data creates a post_like" do
      assert {:ok, %PostLike{} = post_like} = Content.create_post_like(@valid_attrs)
    end

    test "create_post_like/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_post_like(@invalid_attrs)
    end

    test "update_post_like/2 with valid data updates the post_like" do
      post_like = post_like_fixture()
      assert {:ok, post_like} = Content.update_post_like(post_like, @update_attrs)
      assert %PostLike{} = post_like
    end

    test "update_post_like/2 with invalid data returns error changeset" do
      post_like = post_like_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_post_like(post_like, @invalid_attrs)
      assert post_like == Content.get_post_like!(post_like.id)
    end

    test "delete_post_like/1 deletes the post_like" do
      post_like = post_like_fixture()
      assert {:ok, %PostLike{}} = Content.delete_post_like(post_like)
      assert_raise Ecto.NoResultsError, fn -> Content.get_post_like!(post_like.id) end
    end

    test "change_post_like/1 returns a post_like changeset" do
      post_like = post_like_fixture()
      assert %Ecto.Changeset{} = Content.change_post_like(post_like)
    end
  end

  describe "pcomments" do
    alias Backer.Content.PostComment

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def post_comment_fixture(attrs \\ %{}) do
      {:ok, post_comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_post_comment()

      post_comment
    end

    test "list_pcomments/0 returns all pcomments" do
      post_comment = post_comment_fixture()
      assert Content.list_pcomments() == [post_comment]
    end

    test "get_post_comment!/1 returns the post_comment with given id" do
      post_comment = post_comment_fixture()
      assert Content.get_post_comment!(post_comment.id) == post_comment
    end

    test "create_post_comment/1 with valid data creates a post_comment" do
      assert {:ok, %PostComment{} = post_comment} = Content.create_post_comment(@valid_attrs)
      assert post_comment.content == "some content"
    end

    test "create_post_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_post_comment(@invalid_attrs)
    end

    test "update_post_comment/2 with valid data updates the post_comment" do
      post_comment = post_comment_fixture()
      assert {:ok, post_comment} = Content.update_post_comment(post_comment, @update_attrs)
      assert %PostComment{} = post_comment
      assert post_comment.content == "some updated content"
    end

    test "update_post_comment/2 with invalid data returns error changeset" do
      post_comment = post_comment_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Content.update_post_comment(post_comment, @invalid_attrs)

      assert post_comment == Content.get_post_comment!(post_comment.id)
    end

    test "delete_post_comment/1 deletes the post_comment" do
      post_comment = post_comment_fixture()
      assert {:ok, %PostComment{}} = Content.delete_post_comment(post_comment)
      assert_raise Ecto.NoResultsError, fn -> Content.get_post_comment!(post_comment.id) end
    end

    test "change_post_comment/1 returns a post_comment changeset" do
      post_comment = post_comment_fixture()
      assert %Ecto.Changeset{} = Content.change_post_comment(post_comment)
    end
  end

  describe "pcomment_likes" do
    alias Backer.Content.PCommentLike

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def p_comment_like_fixture(attrs \\ %{}) do
      {:ok, p_comment_like} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_p_comment_like()

      p_comment_like
    end

    test "list_pcomment_likes/0 returns all pcomment_likes" do
      p_comment_like = p_comment_like_fixture()
      assert Content.list_pcomment_likes() == [p_comment_like]
    end

    test "get_p_comment_like!/1 returns the p_comment_like with given id" do
      p_comment_like = p_comment_like_fixture()
      assert Content.get_p_comment_like!(p_comment_like.id) == p_comment_like
    end

    test "create_p_comment_like/1 with valid data creates a p_comment_like" do
      assert {:ok, %PCommentLike{} = p_comment_like} = Content.create_p_comment_like(@valid_attrs)
    end

    test "create_p_comment_like/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_p_comment_like(@invalid_attrs)
    end

    test "update_p_comment_like/2 with valid data updates the p_comment_like" do
      p_comment_like = p_comment_like_fixture()
      assert {:ok, p_comment_like} = Content.update_p_comment_like(p_comment_like, @update_attrs)
      assert %PCommentLike{} = p_comment_like
    end

    test "update_p_comment_like/2 with invalid data returns error changeset" do
      p_comment_like = p_comment_like_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Content.update_p_comment_like(p_comment_like, @invalid_attrs)

      assert p_comment_like == Content.get_p_comment_like!(p_comment_like.id)
    end

    test "delete_p_comment_like/1 deletes the p_comment_like" do
      p_comment_like = p_comment_like_fixture()
      assert {:ok, %PCommentLike{}} = Content.delete_p_comment_like(p_comment_like)
      assert_raise Ecto.NoResultsError, fn -> Content.get_p_comment_like!(p_comment_like.id) end
    end

    test "change_p_comment_like/1 returns a p_comment_like changeset" do
      p_comment_like = p_comment_like_fixture()
      assert %Ecto.Changeset{} = Content.change_p_comment_like(p_comment_like)
    end
  end
end
