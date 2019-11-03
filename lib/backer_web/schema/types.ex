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
    field(:id, :id)
    field(:background, :string)
    field(:tagline, :string)
    field(:backer_count, :integer)
    field(:post_count, :integer)
    field(:backer, :backer)
  end

  object :post do
    field(:id)
    field(:content, :string)
    field(:featured_image, :string)
    field(:featured_link, :string)
    field(:featured_video, :string)
    field(:like_count, :integer)
    field(:comment_count, :integer)
    field(:min_tier, :integer)
    field(:title, :string)
    field(:type, :string)
    field(:publish_status)
    field(:donee, :donee)
    field(:comment, :pcomment)
  end

  object :ownpost do
    field(:id)
    field(:content, :string)
    field(:featured_image, :string)
    field(:featured_link, :string)
    field(:featured_video, :string)
    field(:like_count, :integer)
    field(:comment_count, :integer)
    field(:min_tier, :integer)
    field(:title, :string)
    field(:type, :string)
    field(:publish_status)
    field(:donee, :donee)
    field(:comment, :pcomment)
    field(:is_liked, :boolean)
  end

  object :pcomment do
    field(:content, :string)
    field(:like_count, :integer)
    field(:is_featured, :boolean)
  end
end
