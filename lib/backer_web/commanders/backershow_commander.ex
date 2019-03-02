defmodule BackerWeb.BackershowCommander do
  use Drab.Commander, access_session: [:current_backer_id]

  alias Backer.Content
  alias Backer.Account


  defhandler like_post(socket, sender, post_id) do
    {:ok, old_post} = Drab.Live.peek(socket, :post)    
    backer_id = Drab.Core.get_session(socket, :current_backer_id)
    like_result = Backer.Content.like_post(%{"post_id" => post_id, "backer_id" => backer_id})  

    case like_result do
      {:ok, %{like: _like, post: post}} ->
              IO.inspect(post)
              new_post = Map.put(old_post, :like_count, post.like_count)
              broadcast_poke socket, post: new_post
        _other -> 
              broadcast_poke socket, post: old_post
    end
  end


  defhandler like_comment(socket, sender, comment_id) do
    {:ok, old_post} = Drab.Live.peek(socket, :post)
    backer_id = Drab.Core.get_session(socket, :current_backer_id)

    like_attempt = Backer.Content.like_post_comment(%{"pcomment_id" => comment_id, "backer_id" => backer_id})
    
    case like_attempt do
      {:ok, %{comment_like: _comment_like, post_comment: post_comment}} ->
          new_comment = old_post.comments |> Enum.map(fn x -> adjust_like_count_comment(x, post_comment) end)
          new_post = old_post |> Map.put(:comments, new_comment)
          broadcast_poke(socket, post: new_post)
      _ -> broadcast_poke(socket, post: old_post)
    end

  end
  

  defp adjust_like_count_comment(comments, comment) do 
    if comments.id == comment.id do
      Map.put(comments, :like_count, comment.like_count)
    else
      comments
    end    
  end



  defhandler comment(socket, sender, post_id) do

    {:ok, old_post} = Drab.Live.peek(socket, :post)
    # get backer id
    backer_id = Drab.Core.get_session(socket, :current_backer_id)

    # try insert comment
    backer = Account.get_backer!(backer_id)
    text = sender.params["comment_content"]
    attrs = %{"backer_id" => backer_id, "content" => text, "post_id" => post_id}
    case Content.create_post_comment_multi(attrs) do
      {:ok, %{comment: comment, update_featured: update_featured, post: post}} ->
              last_comment = %{
                              avatar: backer.avatar,
                              content: comment.content,
                              display_name: backer.display_name,
                              id: backer.id,
                              inserted_at: comment.inserted_at,
                              is_featured: true,
                              like_count: comment.like_count,
                              username: backer.username
                            }
              # tambah comment ke list yang sudah ada 
              new_post = old_post |> Map.put(:comment_count, post.comment_count) |> Map.put(:comments, old_post.comments ++ [last_comment])
              broadcast_poke(socket, post: new_post)
        other ->
              broadcast_poke(socket, post: old_post)
    end
  end

  onload(:page_loaded)

  # Drab Callbacks
  def page_loaded(socket) do



  end


end
