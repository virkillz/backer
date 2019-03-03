defmodule CUID do
  @moduledoc """
  CUID is for **Cluster-Unique ID**. It's shorter than UUID, case sensitive, and URL-safe.

  The generated ID is guaranteed to be unique among the BEAM cluster
  if there are no more than 65536 nodes in the cluster,
  and the request rate is lower than 256 req/(node * millisec).

  ## Examples

      iex> CUID.start_link(CUID)
      iex> CUID.gen(CUID)
      "AWAAtXL1doYA"

  """

  use Agent
  use Bitwise

  @doc """
  Start a `CUID` process linked to the current process.
  """
  def start_link(name) do
    case Agent.start_link(fn -> 0 end, name: name) do
      {:error, {:already_started, _}} -> :ignore
      other -> other
    end
  end

  @doc """
  Generate a CUID.
  """
  def gen(server) do
    now = System.os_time(:millisecond)  # 48 bits
    node_name_hash = Node.self() |> Atom.to_charlist() |> Enum.reduce(0, fn(char, hash) ->
      ((hash <<< 5) - hash + char) &&& 0xFFFF
    end)  # 32 bits
    n = Agent.get_and_update(server, fn n -> {n, (n + 1) &&& 0xFF} end)  # 16 bits
    <<now::48, node_name_hash::16, n::8>> |> Base.url_encode64(padding: false)
  end
end