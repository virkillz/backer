defmodule Backer.Account.BackerResolver do
  # import lib/graphql/accounts/accounts.ex as Accounts
  alias Backer.Account
  alias Backer.Content
  alias Backer.Finance

  def list_backer(_, _args, _info) do
    {:ok, Account.list_backers()}
  end

  def my_info(satu, dua, %{context: %{my_info: backer}}) do
    {:ok, backer}
  end

  def my_info(_parent, _args, info) do
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

  def find_backer(_parent, %{username: username}, _resolution) do
    case Account.get_backer(%{"username" => username}) do
      nil ->
        {:error, "Backer with username #{username} not found"}

      backer ->
        {:ok, backer}
    end
  end

  def find_backer(_parent, _other, _resolution) do
    {:error, "not found"}
  end

  def find_donee(_parent, %{username: username}, _resolution) do
    case Account.get_donee(%{"username" => username}) do
      nil ->
        {:error, "Backer with username #{username} not found"}

      donee ->
        {:ok, donee}
    end
  end

  def find_backer(_parent, _other, _resolution) do
    {:error, "not found"}
  end

  def list_donee_limit(_, %{limit: limit}, _) do
    {:ok, Account.list_random_donee(limit)}
  end

  def list_my_outgoing_invoices(_, _, %{context: %{my_info: backer}}) do
    {:ok, Finance.list_invoices(%{"backer_id" => backer.id})}
  end

  def list_donee_limit(_, _, _) do
    {:ok, Account.list_random_donee(10)}
  end

  def login(_, %{email: email, password: password}, _) do
    case Account.authenticate_backer_front(email, password) do
      {:ok, backer} ->
        {:ok,
         %{
           jwt: build_token(backer.id),
           username: backer.username,
           display_name: backer.display_name,
           avatar: backer.avatar,
           is_donee: backer.is_donee
         }}

      _ ->
        {:error, "Invalid credentials"}
    end
  end

  defp build_token(id) do
    {:ok, jwt, _} = Backer.Auth.Guardian.encode_and_sign(%{id: id}) |> IO.inspect()
    jwt
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

  def my_post(_, _, c) do
    # IO.inspect(c)
    {:error, "Sorry you must be logged in"}
  end
end
