alias Backer.Repo
alias Backer.Account.User
alias Backer.Gamification.Badge
alias Backer.Masterdata.Category

Repo.insert!(%User{
  fullname: "Joe Admin",
  username: "administrator",
  password_hash: "$2b$12$8As.fIX4fQsbZuhcIhKr7OU3fqxaaPsfYuFZ/S6fUEDd2HDkzN.Tu",
  avatar: "/images/default.png",
  role: "administrator"
})

Repo.insert!(%Badge{
  title: "Light Backer"
})

Repo.insert!(%Badge{
  title: "Heavy Backer"
})

Repo.insert!(%Badge{
  title: "Ultra Backer"
})

Repo.insert!(%Category{
  name: "Social",
  is_active: true
})

Repo.insert!(%Title{
  name: "Non Profit Organization",
  is_active: true
})
