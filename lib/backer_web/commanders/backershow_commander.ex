defmodule BackerWeb.BackershowCommander do
  use Drab.Commander, access_session: [:current_backer_id]

  alias Backer.Content  
  alias Backer.Account
  # Place your event handlers here
  #
  # defhandler single_button(socket, sender) do
  #   IO.inspect(sender)
  #   set_prop socket, "div.jumbotron p.lead", innerHTML: "Clicked the button!"
  # end


  defhandler comment(socket, sender, post_id) do



    backer_id = Drab.Core.get_session(socket, :current_backer_id) 
    text = sender.params["comment"]

    IO.inspect(backer_id)
    IO.inspect(text)

    attrs = %{"backer_id" => backer_id, "content" => text, "post_id" => post_id}
    Content.create_post_comment(attrs)

    {posts , comments} = Content.get_post(%{"id" => post_id})

    post = Map.put(posts, :comments, comments)  

    # backer = Account.get_backer!(backer_id)
    # {donation, rawposts} = Content.timeline(%{"backer_id" => backer_id})
    # posts = rawposts |> Enum.map(fn x -> Map.put(x, :current_avatar, backer.avatar) end)     

    poke socket, post: post
  end  



  onload :page_loaded
  
  # Drab Callbacks
  def page_loaded(socket) do

  end
end
