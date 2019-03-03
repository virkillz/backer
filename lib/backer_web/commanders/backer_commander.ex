defmodule BackerWeb.BackerCommander do
  use Drab.Commander, access_session: [:current_backer_id]

  alias Backer.Content
  alias Backer.Account

  defhandler save_profile(socket, sender) do
    backer_id = Drab.Core.get_session(socket, :current_backer_id)  

  insert_html(socket, "#save_profile_result", :afterbegin, 
  """
  <div class="alert alert-success alert-dismissible">
    <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
    <strong>Success!</strong> This alert box could indicate a successful or positive action.
  </div>
  """
  )

  # insert_html(socket, "#save_profile_result", :afterbegin, 'kntl')  
  end



  defhandler comment(socket, sender, post_id) do
    backer_id = Drab.Core.get_session(socket, :current_backer_id)
    text = sender.params["comment"]

    attrs = %{
      "backer_id" => backer_id,
      "content" => text,
      "post_id" => post_id,
      "is_featured" => true
    }

    Content.create_post_comment_multi(attrs)

    backer = Account.get_backer!(backer_id)
    {donation, rawposts} = Content.timeline(backer_id)
    posts = rawposts |> Enum.map(fn x -> Map.put(x, :current_avatar, backer.avatar) end)

    poke(socket, posts: posts)
  end

  defhandler testpeek(socket, sender) do
    {:ok, posts} = Drab.Live.peek(socket, :posts)

    # IO.inspect(posts)
    current_timeline =
      posts
      |> Enum.map(fn x -> x.id end)
      |> Content.list_post_from_array()
      |> IO.inspect()

    poke(socket, posts: [])
  end

  defhandler like(socket, sender, post_id) do
    backer_id = Drab.Core.get_session(socket, :current_backer_id)

    attrs = %{"backer_id" => backer_id, "post_id" => post_id}
    Content.create_post_like_multi(attrs)

    backer = Account.get_backer!(backer_id)
    {donation, rawposts} = Content.timeline(%{"backer_id" => backer_id})
    posts = rawposts |> Enum.map(fn x -> Map.put(x, :current_avatar, backer.avatar) end)

    poke(socket, posts: posts)
  end

  # You can use something in here at page load. same like ajax call.
  # onload :page_loaded

  # def page_loaded(socket) do
  # end
end
