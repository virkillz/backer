defmodule Backer.Account.BackerResolver do
  # import lib/graphql/accounts/accounts.ex as Accounts
  alias Backer.Account
  alias Backer.Content

  def list_backer(_, _args, _info) do
    {:ok, Account.list_backers()}
  end

  def my_info(satu, dua, %{context: %{my_info: backer}}) do
    {:ok, backer}
  end

  def my_info(_parent, _args, _info) do
    {:error, "not authorized"}
  end

  def all_post(_parent, %{limit: limit}, _info) do
    case Content.list_public_post(limit) do
      nil -> {:error, "Can't fetch the post data"}
      result -> {:ok, result}
    end
  end

  def all_post(_parent, _args, _info) do
    case Content.list_public_post(10) do
      nil -> {:error, "Can't fetch the post data"}
      result -> {:ok, result}
    end
  end

  def find_backer(_parent, %{id: id}, _resolution) do
    case Account.get_backer_preload_donee(id) do
      nil ->
        {:error, "Backer ID #{id} not found"}

      backer ->
        {:ok, backer}
    end
  end

  def find_backer(_parent, _other, _resolution) do
    {:error, "not found"}
  end

  def recommended_donee(_, _, _) do
    {:ok, Account.list_random_donee(3)}
  end

  def my_post(_, _, %{context: %{my_info: backer}}) do
    if backer.is_donee do
      {:ok, Content.list_own_posts(backer.donee.id, backer.id, 10, 0) |> IO.inspect()}
    else
      {:error, "Sorry you are not donee"}
    end
  end

  def my_post(_, _, _) do
    {:error, "Sorry you must be logged in"}
  end
end
