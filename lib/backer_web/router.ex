defmodule BackerWeb.Router do
  use BackerWeb, :router

  # -----------------pipeline ----------------

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug Phoenix.LiveView.Flash
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(BackerWeb.Plugs.SetCurrentUser)
    plug(BackerWeb.Plugs.SetCurrentBacker)
    plug(BackerWeb.Plugs.SetNotification)
    plug BackerWeb.Locale
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:fetch_session)
    plug(BackerWeb.Plugs.SetCurrentBacker)
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

  pipeline :graphql do
    # custom plug written into lib/graphql_web/plug/context.ex folder
    plug BackerWeb.Context
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

    resources "/backingaggregates", BackingAggregateController, only: [:index, :show]
    resources "/contacts", ContactController
    resources "/metadatas", MetadataController

    # masterdata
    resources("/categories", CategoryController)
    resources("/titles", TitleController)
    resources "/banks", BankController

    resources("/general_settings", SettingController)
    resources("/backers", BackerController)
    resources("/donees", DoneeController)
    resources "/payment_accounts", PaymentAccountController
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

    # finance
    get("/invoices/newbacking", InvoiceController, :newbacking)
    get("/invoices/newdeposit", InvoiceController, :newdeposit)
    post("/invoices/create_deposit", InvoiceController, :create_deposit)
    post("/invoices/create_backing", InvoiceController, :create_backing)
    resources("/invoices", InvoiceController, only: [:index, :edit, :update, :show])
    resources("/incoming_payments", IncomingPaymentController)
    resources "/settlements", SettlementController
    get "/settlements/new/:id", SettlementController, :build_settlement
    resources("/donations", DonationController, only: [:index, :show])
    resources("/mutations", MutationController, only: [:index, :show, :delete])

    # Better disable for security reason
    # resources "/settlement_details", SettlementDetailController
    # resources("/invoice_details", InvoiceDetailController, only: [:index, :show])
    # resources("/withdrawals", WithdrawalController)

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

    get("/backerprofile", BackerController, :home_backer_profile)

    get("/home/timeline", BackerController, :home_timeline_live)
    get("/home/timeline/all", BackerController, :home_timeline_all)
    get("/home/support/my-donees", BackerController, :home_support_my_donees)
    get("/home/support/my-backers", BackerController, :home_support_my_backers)
    get("/home/finance/invoice/:id", BackerController, :home_finance_invoice)

    get(
      "/home/support/my-donee/detail/:donee_username",
      BackerController,
      :home_support_my_donee_detail
    )

    get(
      "/home/support/my-backer/detail/:backer_username",
      BackerController,
      :home_support_my_backer_detail
    )

    get("/home/finance/incoming", BackerController, :home_finance_incoming)
    get("/home/finance/outgoing", BackerController, :home_finance_outgoing)
    get("/home/settings/donee", BackerController, :home_settings_donee)
    get("/home/settings/backer", BackerController, :home_setting_backer)
    put("/home/settings/backer", BackerController, :home_setting_backer_post)
    post("/home/settings/backer/user-link", BackerController, :home_setting_backer_link_post)
    get("/backerzone", BackerController, :backerzone_default)
    get("/home", BackerController, :home)
    get("/notifications", BackerController, :home_notifications)
    get("/private/notification", BackerController, :backerzone_notification_api)
    get("/private/notification/reset-counter", BackerController, :reset_counter)

    get("/backerzone/timeline", BackerController, :timeline)
    get("/backerzone/timeline/:id", BackerController, :show_post)

    get("/backerzone/my-donee-list", BackerController, :backerzone_my_donee_list)
    get("/backerzone/my-donee/:donee_username", BackerController, :backerzone_my_donee_detail)

    put(
      "/backerzone/my-donee/:donee_username",
      BackerController,
      :backerzone_my_donee_detail_post
    )

    get("/backerzone/payment-history", BackerController, :backerzone_payment_history)
    get("/backerzone/invoice/:id", BackerController, :backerzone_invoice_detail)
    get("/backerzone/profile-setting", BackerController, :backerzone_profile_setting)
    put("/backerzone/profile-setting", BackerController, :backerzone_profile_setting_post)
    get("/backerzone/notifications/:id", BackerController, :backerzone_notification_forwarder)
    post("/backerzone/user_links", BackerController, :backerzone_user_link_post)
    get("/backerzone/timeline-live", BackerController, :backerzone_timeline_live)
    get("/backerzone/timeline-live/:post_id", BackerController, :backerzone_timeline_post_live)
    # post("/backerzone/link-setting", BackerController, :backerzone_link_setting_post)

    post("/checkout", DoneeController, :checkout_post)
  end

  # This route area is for signed in donee
  scope "/", BackerWeb do
    pipe_through([:browser, :backer_sign_check, :is_donee_check])

    get("/doneezone", DoneeController, :doneezone_default)
    get("/doneeprofile", DoneeController, :home_donee_profile)

    get("/doneezone/posts", DoneeController, :doneezone_posts)
    get("/doneezone/timeline-live", DoneeController, :doneezone_timeline_live)

    get("/doneezone/preview", DoneeController, :doneezone_preview)
    get("/doneezone/about", DoneeController, :doneezone_about)
    get("/doneezone/backers", DoneeController, :doneezone_backers)
    get("/doneezone/finance", DoneeController, :doneezone_finance)
    get("/doneezone/setting", DoneeController, :doneezone_setting)
    put("/doneezone/setting", DoneeController, :doneezone_setting_post)
    get("/doneezone/tiers", DoneeController, :doneezone_tiers)
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

  # Must not sign in. SIgned in user cannot access following pages.
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

  # This is route for graphql endpoint
  scope "/" do
    pipe_through([:api, :graphql])

    forward "/api", Absinthe.Plug, schema: BackerWeb.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: BackerWeb.Schema,
      interface: :simple
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
