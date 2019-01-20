defmodule BackerWeb.Router do
  use BackerWeb, :router

  # -----------------pipeline ----------------

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(BackerWeb.Plugs.SetCurrentUser)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(Backer.Auth.AuthAccessPipeline)
  end

  # ----------------- scope route ----------------

  scope "/admin", BackerWeb do
    # Use the default browser stack
    pipe_through([:browser, :auth])

    get("/", UserController, :dashboard)
    get("/profile", UserController, :profile)
    get("/locked", UserController, :locked)
    resources("/activity", ActivityController, only: [:index, :show, :delete])
    resources("/user", UserController)
    get("/logout", UserController, :logout)

    # please make menu 
    resources("/categories", CategoryController)
    resources("/titles", TitleController)
    resources("/general_settings", SettingController)
    resources("/backers", BackerController)
    resources("/pledgers", PledgerController)
    resources("/badges", BadgeController)
    resources("/badge_members", BadgeMemberController, except: [:index])
    get("/badge_members/new/:badgeid", BadgeMemberController, :newmember)

    resources("/points", PointController)
    resources("/tiers", TierController)
    resources("/forums", ForumController)   
    resources("/forum_like", ForumLikeController)
    resources("/fcomments", ForumCommentController)
    get("/fcomments/new/:forumid", ForumCommentController, :newcomment)     
    resources("/fcomment_like", FCommentLikeController)
    resources("/posts", PostController)
    resources("/post_likes", PostLikeController)
    resources("/pcomments", PostCommentController)
    get("/pcomments/new/:post_id", PostCommentController, :newcomment)
    resources("/pcomment_likes", PCommentLikeController)

    # get "/*path", DefaultController, :page_404
  end

  scope "/", BackerWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/login", PageController, :login)
    get("/lgn", PageController, :lgn)
    get("/register", PageController, :register)
    post("/login", PageController, :auth)
    post("/register", PageController, :createuser)
    get("/recover", PageController, :recover)
    get("/admin/login", UserController, :login)
    post("/admin/login", UserController, :auth)
    get("/signout", PageController, :signout)
  end

  # Other scopes may use custom stacks.
  # scope "/api", BackerWeb do
  #   pipe_through :api
  # end
end
