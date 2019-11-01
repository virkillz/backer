defmodule Backer.Account.BackerResolver do
  # import lib/graphql/accounts/accounts.ex as Accounts
  alias Backer.Account

  def list_backer(satu, _args, _info) do
    IO.inspect(satu)
    {:ok, Account.list_backers()}
  end

  def find_backer(_parent, %{id: id}, _resolution) do
    case Account.get_backer_preload_donee(id) do
      nil ->
        {:error, "Backer ID #{id} not found"}

      backer ->
        {:ok, backer}
    end
  end
end
