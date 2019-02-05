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
    plug(BackerWeb.Plugs.SetCurrentBacker)
    plug(BackerWeb.Plugs.SetNotification)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(Backer.Auth.AuthAccessPipeline)
  end

  pipeline :backer_sign_check do
    plug(BackerWeb.Plugs.BackerSignCheck)
  end

  # This route area is for admin Portal
  scope "/admin", BackerWeb do
    pipe_through([:browser, :auth])

    get("/", UserController, :dashboard)
    get("/profile", UserController, :profile)
    get("/locked", UserController, :locked)
    resources("/activity", ActivityController, only: [:index, :delete])
    resources("/user", UserController)
    get("/logout", UserController, :logout)

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

    get("/invoices/newbacking", InvoiceController, :newbacking)
    get("/invoices/newdeposit", InvoiceController, :newdeposit)
    post("/invoices/create_deposit", InvoiceController, :create_deposit)
    post("/invoices/create_backing", InvoiceController, :create_backing)
    resources("/invoices", InvoiceController, except: [:new, :create])
    resources("/incoming_payments", IncomingPaymentController)
    resources("/invoice_details", InvoiceDetailController, only: [:index, :show])
    resources("/donations", DonationController)
    resources("/mutations", MutationController, only: [:index, :show, :delete])
    resources("/withdrawals", WithdrawalController)

    get("/approval", FinanceController, :index)
    get("/approval/:id", FinanceController, :process)
    put("/approval/:id", FinanceController, :update)

    resources("/articles", ArticleController)
  end

  # This route area is for signed in backer
  scope "/", BackerWeb do
    pipe_through([:browser, :backer_sign_check])

    get("/backer/:username/timeline", BackerController, :timeline)
    get("/backer/:username/finance", BackerController, :finance)
    get("/backer/:username/backing-history", BackerController, :backing_history)
    get("/backer/:username/profile-setting", BackerController, :profile_setting)
  end

  # This route area is for public route
  scope "/", BackerWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/login", PageController, :login)
    get("/register", PageController, :register)
    post("/login", PageController, :auth)
    post("/register", PageController, :createuser)
    get("/recover", PageController, :recover)
    get("/admin/login", UserController, :login)
    post("/admin/login", UserController, :auth)
    get("/signout", PageController, :signout)
    get("/backer", BackerController, :featured)
    get("/pledger", PledgerController, :featured)

    get("/backer/:username", BackerController, :overview)
    get("/backer/:username/badges", BackerController, :badges)
    get("/backer/:username/backerfor", BackerController, :backerfor)

    get("/verify", PageController, :verify)
    get("/resend-email", PageController, :resend)
    get("/forgot-password", PageController, :forgot_password)
    post("/forgot-password", PageController, :forgot_password_post)
    get("/change-password", PageController, :change_password)
    put("/change-password", PageController, :change_password_post)  
    post("/change-password", PageController, :change_password_post)  
    get("/pledger/:username", PledgerController, :overview)
    get("/pledger/:username/posts", PledgerController, :posts)
    get("/pledger/:username/backers", PledgerController, :backers)
    get("/pledger/:username/forum", PledgerController, :forum)
    get("/pledger/:username/tier", PledgerController, :tier)
    get("/pledger/:username/checkout", PledgerController, :checkout)

    get("/page/:slug", PageController, :static_page)
    get("/explore", PledgerController, :explore)
    get("/category/:id", CategoryController, :list_pledger)
    get("/404", PageController, :page404)
    get("/505", PageController, :page505)
    get("/:backer", PledgerController, :redirector)
  end

  # Other scopes may use custom stacks.
  # scope "/api", BackerWeb do
  #   pipe_through :api
  # end
end
