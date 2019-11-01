defmodule BackerWeb.Schema.Types do
  use Absinthe.Schema.Notation

  object :backer do
    field(:id, :id)
    field(:avatar, :string)
    field(:display_name, :string)
    field(:username, :string)
    field(:donee, :donee)
    field(:is_donee, :boolean)
  end

  object :donee do
    field(:background, :string)
    field(:tagline, :string)
  end
end
