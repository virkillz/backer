defmodule BackerWeb.Context do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      %{my_info: current_user}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    case Backer.Auth.Guardian.resource_from_token(token) do
      {:ok, user, _claims} ->
        {:ok, user}

      _ ->
        {:error, :unauthorized}
    end
  end
end
