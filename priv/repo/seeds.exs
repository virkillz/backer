alias Backer.Repo
alias Backer.Account.User
alias Backer.Gamification.Badge
alias Backer.Masterdata.Category
alias Backer.Masterdata.Title
alias Backer.Masterdata.Tier
alias Backer.Account.Donee
alias Backer.Setting
alias Backer.Account.Backer, as: Backerz

Repo.insert!(%User{
  fullname: "Joe Admin",
  username: "administrator",
  password_hash: "$2b$12$8As.fIX4fQsbZuhcIhKr7OU3fqxaaPsfYuFZ/S6fUEDd2HDkzN.Tu",
  avatar: "/images/default.png",
  role: "administrator"
})

Repo.insert!(%Tier{
  title: "Light Backer",
  amount: 10_000
})

Repo.insert!(%Tier{
  title: "Heavy Backer",
  amount: 50_000
})

Repo.insert!(%Tier{
  title: "Ultra Backer",
  amount: 100_000
})

Repo.insert!(%Category{
  name: "Social",
  is_active: true
})

Repo.insert!(%Title{
  name: "Non Profit Organization",
  is_active: true
})

Repo.insert!(%Backerz{
  username: "backer-1",
  display_name: "Robin Hood",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "backer1@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default1.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "backer-2",
  display_name: "Peter Pan",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "backer2@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default2.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "backer-3",
  display_name: "Clark Kent",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "backer3@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default3.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "backer-4",
  display_name: "Bruce Wayne",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "backer4@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default4.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "backer-5",
  display_name: "Tony Start",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "backer5@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default5.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "backer-6",
  display_name: "Ronald Mc Donald",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "backer6@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default6.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "backer-7",
  display_name: "Fidel Castro",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "backer7@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default7.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "backer-8",
  display_name: "Sandra Bullock",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "backer8@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default8.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "backer-9",
  display_name: "Benedict Cumberbach",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "backer9@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default9.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "backer-10",
  display_name: "Anthony Robins",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "backer10@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default10.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "donee-1",
  display_name: "Sekolah Ngamen Kerja",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "donee1@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default1.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_donee: true,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "donee-2",
  display_name: "Kucing Malas",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "donee2@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default2.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_donee: true,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "donee-3",
  display_name: "KNTL",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "donee3@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default3.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_donee: true,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "donee-4",
  display_name: "Partai Kapitalis Indonesia",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "donee4@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default4.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_donee: true,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "donee-5",
  display_name: "Sedekah Seribu Sehari",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "donee5@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default5.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_donee: true,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Backerz{
  username: "donee-6",
  display_name: "Komunitas Tuli",
  passwordhash: "$2b$12$fUp0Rsoo29gGq231gSvRZekH6vP4VRfGU0whbltyB48PSxaN6I8MW",
  backer_bio: "A generous backer in the making",
  email: "donee6@tester.com",
  id_type: "ktp",
  avatar: "/assets/images/bg/avatar-default6.jpg",
  email_verification_code: "84802c88-5a41-4a86-89f9-a7382036a63e",
  is_email_verified: true,
  is_phone_verified: false,
  is_donee: true,
  is_listed: true,
  is_searchable: true
})

Repo.insert!(%Donee{
  background: "/assets/images/bg/ngamen.jpeg",
  is_listed: true,
  tagline: "11",
  is_searchable: true,
  backer_id: 11,
  category_id: 1,
  title_id: 1,
  backer_count: 17,
  post_count: 42
})

Repo.insert!(%Donee{
  background: "/assets/images/bg/kucingmalas.jpeg",
  is_listed: true,
  tagline: "11",
  is_searchable: true,
  backer_id: 12,
  category_id: 1,
  title_id: 1,
  backer_count: 17,
  post_count: 42
})

Repo.insert!(%Donee{
  background: "/assets/images/bg/podcast.jpeg",
  is_listed: true,
  tagline: "11",
  is_searchable: true,
  backer_id: 13,
  category_id: 1,
  title_id: 1,
  backer_count: 17,
  post_count: 42
})

Repo.insert!(%Donee{
  background: "/assets/images/bg/kapitalis.jpeg",
  is_listed: true,
  tagline: "11",
  is_searchable: true,
  backer_id: 14,
  category_id: 1,
  title_id: 1,
  backer_count: 17,
  post_count: 42
})

Repo.insert!(%Donee{
  background: "/assets/images/bg/donate.jpeg",
  is_listed: true,
  tagline: "11",
  is_searchable: true,
  backer_id: 15,
  category_id: 1,
  title_id: 1,
  backer_count: 17,
  post_count: 42
})

Repo.insert!(%Donee{
  background: "/assets/images/bg/tuli.jpeg",
  is_listed: true,
  tagline: "11",
  is_searchable: true,
  backer_id: 16,
  category_id: 1,
  title_id: 1,
  backer_count: 17,
  post_count: 42
})

Repo.insert!(%Setting{
  group: "landing page",
  key: "main_featured_donee",
  value: "1"
})

Repo.insert!(%Setting{
  group: "landing page",
  key: "main_featured_donee_description",
  value: "Lorem ipsum"
})
