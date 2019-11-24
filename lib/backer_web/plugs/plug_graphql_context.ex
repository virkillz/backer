defmodule BackerWeb.Context do
  @behaviour Plug

  import Plug.Conn
  import Ecto.Query, only: [where: 2]

  alias Backer.{Repo, User}

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    IO.inspect(conn)

    if conn.assigns.backer_signed_in? do
      %{my_info: conn.assigns.current_backer}
    else
      %{}
    end

    # with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
    #      {:ok, current_user} <- authorize(token) do
    #   %{current_user: current_user}
    # else
    #   _ -> %{}
    # end
  end

  defp authorize(token) do
    User
    |> where(token: ^token)
    |> Repo.one()
    |> case do
      nil -> {:error, "invalid authorization token"}
      user -> {:ok, user}
    end
  end
end
