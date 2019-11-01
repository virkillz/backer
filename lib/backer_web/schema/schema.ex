defmodule BackerWeb.Schema do
  use Absinthe.Schema
  import_types(BackerWeb.Schema.Types)

  query do
    @desc "Get a backer from username"
    field :backer, :backer do
      arg(:id, non_null(:id))
      resolve(&Backer.Account.BackerResolver.find_backer/3)
    end

    @desc "List of all backers with limit"
    field :backer, list_of(:backer) do
      arg(:limit)
      resolve(&Backer.Account.BackerResolver.list_backer_limit/3)
    end

    @desc "List of all backers"
    field :backer, list_of(:backer) do
      resolve(&Backer.Account.BackerResolver.list_backer/3)
    end
  end
end
