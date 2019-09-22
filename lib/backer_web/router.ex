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

  pipeline :is_donee_check do
    plug(BackerWeb.Plugs.DoneeCheck)
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
    resources("/donees", DoneeController)
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
    get("/approval/:id", FinanceController, :approval_form)
    put("/approval/:id", FinanceController, :update)

    resources("/articles", ArticleController)
  end

  # This route area is for signed in backer
  scope "/", BackerWeb do
    pipe_through([:browser, :backer_sign_check])

    get("/home", BackerController, :home)

    get("/backerzone/timeline", BackerController, :timeline)
    get("/backerzone/timeline/:id", BackerController, :show_post)

    get("/backerzone/my-donee-list", BackerController, :my_donee_list)
    get("/backerzone/payment-history", BackerController, :payment_history)
    get("/backerzone/profile-setting", BackerController, :profile_setting)

    get("/home/invoice/:id", BackerController, :invoice_display)
    get("/home/overview", BackerController, :overview)
    get("/home/finance", BackerController, :finance)
    get("/home/backing-history", BackerController, :backing_history)
    get("/home/backing", BackerController, :backing)
    get("/home/profile-setting", BackerController, :profile_setting)
    put("/home/edit_profile", BackerController, :profile_setting_update)

    get("/donee/:username/tier/:tier", DoneeController, :checkout)
    post("/checkout", DoneeController, :checkout_post)
  end

  # This route area is for signed in backer and only for himself
  scope "/", BackerWeb do
    pipe_through([:browser, :backer_self_check])
  end

  # This route area is for signed in donee
  scope "/", BackerWeb do
    pipe_through([:browser, :backer_sign_check, :is_donee_check])

    get("/doneezone/timeline", DoneeController, :timeline)

    get("/doneezone/dashboard", DoneeController, :dashboard)
    get("/doneezone/post", DoneeController, :dashboard_post)
    get("/doneezone/post/show/:id", DoneeController, :dashboard_post_show)
    get("/doneezone/post/edit/:id", DoneeController, :dashboard_post_edit)
    put("/doneezone/post/edit/:id", DoneeController, :dashboard_post_update)

    get("/doneezone/post/new", DoneeController, :dashboard_post_new)
    get("/doneezone/post/new-image", DoneeController, :dashboard_post_new_image)
    get("/doneezone/post/new-video", DoneeController, :dashboard_post_new_video)
    post("/doneezone/post/create", DoneeController, :dashboard_post_create)
    delete("/doneezone/post/delete/:id", DoneeController, :dashboard_post_delete)

    get("/doneezone/backers", DoneeController, :dashboard_backers)
    get("/doneezone/backers/active", DoneeController, :dashboard_backers_active)
    get("/doneezone/backers/inactive", DoneeController, :dashboard_backers_inactive)

    get("/doneezone/earning", DoneeController, :dashboard_earning)
    get("/doneezone/page-setting", DoneeController, :dashboard_page_setting)
    put("/doneezone/page-setting", DoneeController, :dashboard_page_setting_update)
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

    get("/backer/:username", BackerController, :public_profile)

    get("/donee/:username", DoneeController, :overview)
    get("/donee/:username/posts", DoneeController, :posts)
    # get("/donee/:username/backers", DoneeController, :backers)
    # get("/donee/:username/forum", DoneeController, :forum)
    get("/donee/:username/donate", DoneeController, :donate)
    # get("/donee/:username/checkout", DoneeController, :checkout)

    get("/contact-us", PublicController, :contact_us)
    get("/about-us", PublicController, :about_us)
    get("/forgot-password", PublicController, :forgot_password)
    get("/faq", PublicController, :faq)
    get("/terms", PublicController, :terms)
    get("/privacy-policy", PublicController, :privacy_policy)
    get("/explore", PublicController, :explore)

    get("/category/:id", CategoryController, :list_donee)
    get("/404", PublicController, :page404)
    get("/400", PublicController, :page400)
    get("/505", PublicController, :page505)
    get("/:backer", PublicController, :redirector)
  end
end
