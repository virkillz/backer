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
    plug BackerWeb.Locale
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(Backer.Auth.AuthAccessPipeline)
  end

  # pipeline for user must signed in
  pipeline :backer_sign_check do
    plug(BackerWeb.Plugs.BackerSignCheck)
  end

  # pipeline for user must signed in and params is himself
  pipeline :backer_self_check do
    plug(BackerWeb.Plugs.BackerSignCheck)
    plug(BackerWeb.Plugs.BackerSelfCheck)
  end

  pipeline :must_not_sign_in do
    plug(BackerWeb.Plugs.BackerNonSignCheck)
  end

  pipeline :is_pledger_check do
    plug(BackerWeb.Plugs.PledgerCheck)
  end

  # ============================================================#

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

    get("/home", BackerController, :home)
    get("/home/timeline/:id", BackershowController, :show_post)
    get("/home/invoice/:id", BackerController, :invoice_display)
    get("/home/overview", BackerController, :overview)
    get("/home/finance", BackerController, :finance)
    get("/home/backing-history", BackerController, :backing_history)
    get("/home/backing", BackerController, :backing)
    get("/home/profile-setting", BackerController, :profile_setting)
    put("/home/edit_profile", BackerController, :profile_setting_update)

    get("/pledger/:username/tier/:tier", PledgerController, :checkout)
    post("/checkout", PledgerController, :checkout_post)
  end

  # This route area is for signed in backer and only for himself
  scope "/", BackerWeb do
    pipe_through([:browser, :backer_self_check])
  end

  # This route area is for signed in pledger
  scope "/", BackerWeb do
    pipe_through([:browser, :backer_sign_check, :is_pledger_check])

    get("/dashboard", PledgerController, :dashboard)
    get("/dashboard/post", PledgerController, :dashboard_post)
    get("/dashboard/post/show/:id", PledgerController, :dashboard_post_show)
    get("/dashboard/post/edit/:id", PledgerController, :dashboard_post_edit)
    put("/dashboard/post/edit/:id", PledgerController, :dashboard_post_update)

    get("/dashboard/post/new", PledgerController, :dashboard_post_new)
    get("/dashboard/post/new-image", PledgerController, :dashboard_post_new_image)
    get("/dashboard/post/new-video", PledgerController, :dashboard_post_new_video)
    post("/dashboard/post/create", PledgerController, :dashboard_post_create)
    delete("/dashboard/post/delete/:id", PledgerController, :dashboard_post_delete)

    get("/dashboard/backers", PledgerController, :dashboard_backers)
    get("/dashboard/backers/active", PledgerController, :dashboard_backers_active)
    get("/dashboard/backers/inactive", PledgerController, :dashboard_backers_inactive)

    get("/dashboard/earning", PledgerController, :dashboard_earning)
    get("/dashboard/page-setting", PledgerController, :dashboard_page_setting)
    put("/dashboard/page-setting", PledgerController, :dashboard_page_setting_update)
  end

  # must not sign in
  scope "/", BackerWeb do
    pipe_through([:browser, :must_not_sign_in])

    get("/", PublicController, :index)
    get("/login", PublicController, :login)
    get("/sign_up", PublicController, :sign_up)

    post("/login", PublicController, :auth)
    post("/sign_up", PublicController, :createuser)
    get("/recover", PublicController, :recover)

    get("/verify", PublicController, :verify)
    get("/resend-email", PublicController, :resend)
    get("/forgot-password", PublicController, :forgot_password)
    post("/forgot-password", PublicController, :forgot_password_post)
    get("/change-password", PublicController, :change_password)
    put("/change-password", PublicController, :change_password_post)
    post("/change-password", PublicController, :change_password_post)
  end

  # This route area is for public route
  scope "/", BackerWeb do
    pipe_through(:browser)

    get("/avatar", PublicController, :color)

    get("/admin/login", UserController, :login)
    post("/admin/login", UserController, :auth)
    get("/signout", PublicController, :signout)

    get("/donee/:username", PledgerController, :overview)
    get("/donee/:username/posts", PledgerController, :posts)
    # get("/donee/:username/backers", PledgerController, :backers)
    # get("/donee/:username/forum", PledgerController, :forum)
    # get("/donee/:username/tier", PledgerController, :tier)
    # get("/donee/:username/checkout", PledgerController, :checkout)

    get("/contact-us", PublicController, :contact_us)
    get("/about-us", PublicController, :about_us)
    get("/forgot-password", PublicController, :forgot_password)
    get("/faq", PublicController, :faq)
    get("/terms", PublicController, :terms)
    get("/privacy-policy", PublicController, :privacy_policy)
    get("/explore", PublicController, :explore)

    get("/category/:id", CategoryController, :list_pledger)
    get("/404", PublicController, :page404)
    get("/400", PublicController, :page400)
    get("/505", PublicController, :page505)
    get("/:backer", PledgerController, :redirector)
  end
end
