defmodule BackerWeb.Schema do
  use Absinthe.Schema
  import_types(BackerWeb.Schema.Types)

  query do
    # Private

    @desc "Get personal info. Only when logged in."
    field :my_info, :backer do
      resolve(&Backer.Account.BackerResolver.my_info/3)
    end

    @desc "Get my own post. If logged in and is donee"
    field :my_post, list_of(:ownpost) do
      resolve(&Backer.Account.BackerResolver.my_post/3)
    end

    # Backer

    @desc "List of all backers"
    field :backers, list_of(:backer) do
      resolve(&Backer.Account.BackerResolver.list_backer/3)
    end

    @desc "Get a backer from id"
    field :backer, :backer do
      arg(:id, :integer)
      arg(:username, :string, description: "The desired username")
      resolve(&Backer.Account.BackerResolver.find_backer/3)
    end

    @desc "List of all backers with limit"
    field :list_backer, list_of(:backer) do
      arg(:limit)
      resolve(&Backer.Account.BackerResolver.list_backer_limit/3)
    end

    @desc "List of all donee with limit"
    field :list_donee, list_of(:donee) do
      arg(:limit)
      resolve(&Backer.Account.BackerResolver.list_donee_limit/3)
    end

    @desc "List all my_invoices"
    field :my_outgoing_invoice, list_of(:invoice) do
      resolve(&Backer.Account.BackerResolver.list_my_outgoing_invoices/3)
    end

    @desc "List latest public post"
    field :all_post, list_of(:post) do
      arg(:limit)
      resolve(&Backer.Account.BackerResolver.all_post/3)
    end

    @desc "List latest public post"
    field :all_post, list_of(:post) do
      resolve(&Backer.Account.BackerResolver.all_post/3)
    end

    field :recommended_donee, list_of(:donee) do
      resolve(&Backer.Account.BackerResolver.recommended_donee/3)
    end
  end
end
