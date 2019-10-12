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

    resources "/backingaggregates", BackingAggregateController
    resources "/contacts", ContactController
    resources "/metadatas", MetadataController
    resources("/categories", CategoryController)
    resources("/titles", TitleController)
    resources("/general_settings", SettingController)
    resources("/backers", BackerController)
    resources("/donees", DoneeController)
    resources "/submissions", SubmissionController
    resources "/notifications", NotificationController
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

    get("/email-template/send-email-verification", EmailController, :send_email_verification)
    get("/email-template/send-reset-password-link", EmailController, :send_reset_password_link)
    resources("/articles", ArticleController)
  end

  # This route area is for signed in backer
  scope "/", BackerWeb do
    pipe_through([:browser, :backer_sign_check])

    get("/backerzone", BackerController, :backerzone_default)
    get("/home", BackerController, :home)
    get("/notifications", BackerController, :backerzone_notifications)
    get("/private/notification", BackerController, :backerzone_notification_api)

    get("/backerzone/timeline", BackerController, :timeline)
    get("/backerzone/timeline/:id", BackerController, :show_post)

    get("/backerzone/my-donee-list", BackerController, :backerzone_my_donee_list)
    get("/backerzone/payment-history", BackerController, :backerzone_payment_history)
    get("/backerzone/invoice/:id", BackerController, :backerzone_invoice_detail)
    get("/backerzone/profile-setting", BackerController, :backerzone_profile_setting)
    put("/backerzone/profile-setting", BackerController, :backerzone_profile_setting_post)
    get("/backerzone/notifications/:id", BackerController, :backerzone_notification_forwarder)
    post("/backerzone/user_links", BackerController, :backerzone_user_link_post)
    # post("/backerzone/link-setting", BackerController, :backerzone_link_setting_post)

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

    get("/doneezone", DoneeController, :doneezone_default)
    get("/doneezone/posts", DoneeController, :doneezone_posts)
    get("/doneezone/about", DoneeController, :doneezone_about)
    get("/doneezone/backers", DoneeController, :doneezone_backers)
    get("/doneezone/finance", DoneeController, :doneezone_finance)
    get("/doneezone/setting", DoneeController, :doneezone_setting)
    put("/doneezone/setting", DoneeController, :doneezone_setting_post)
    get("/doneezone/statistic", DoneeController, :doneezone_statistic)

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
    get("/register-donee", PublicController, :register_donee)
    post("/register-donee", PublicController, :register_donee_post)

    get("/verify", PublicController, :verify)
    get("/resend-email", PublicController, :resend)
    get("/forgot-password", PublicController, :forgot_password)
    post("/forgot-password", PublicController, :forgot_password_post)
    get("/reset-password", PublicController, :reset_password)
    post("/reset-password", PublicController, :reset_password_post)
  end

  # This route area is for public route
  scope "/", BackerWeb do
    pipe_through(:browser)

    get("/avatar", PublicController, :color)
    get("/search", PublicController, :search)

    get("/admin/login", UserController, :login)
    post("/admin/login", UserController, :auth)
    get("/signout", PublicController, :signout)

    get("/backer/:username", BackerController, :public_profile)

    get("/donee/:username", DoneeController, :about)
    get("/donee/:username/posts", DoneeController, :posts)
    get("/donee/:username/backers", DoneeController, :backers)
    # get("/donee/:username/forum", DoneeController, :forum)
    get("/donee/:username/donate", DoneeController, :donate)
    post("/donee/:username/donate", DoneeController, :donate_post)
    # get("/donee/:username/checkout", DoneeController, :checkout)

    get("/contact-us", PublicController, :contact_us)
    post("/contact-us", PublicController, :contact_us_post)
    get("/about-us", PublicController, :about_us)
    get("/forgot-password", PublicController, :forgot_password)
    post("/forgot-password", PublicController, :forgot_password_post)
    get("/faq", PublicController, :faq)
    get("/terms", PublicController, :terms)
    get("/privacy-policy", PublicController, :privacy_policy)
    get("/explore", PublicController, :explore)

    get("/category/:id", CategoryController, :list_donee)
    get("/404", PublicController, :page404)
    get("/403", PublicController, :page403)
    get("/400", PublicController, :page400)
    get("/505", PublicController, :page505)
    get("/:backer", PublicController, :redirector)
  end

  scope "/", BackerWeb do
    pipe_through(:api)
    # DELETE THIS WHEN LIVE
    # get("/private/notification", PublicController, :hapus_notification)
  end
end
