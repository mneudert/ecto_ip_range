defmodule EctoIPRange.Util.CIDR do
  @moduledoc false

  alias EctoIPRange.Util.Inet

  @doc """
  Calculate first and last address for an IPv4 notation.

  ## Examples

      iex> parse_ipv4("1.2.3.4", 32)
      {{1, 2, 3, 4}, {1, 2, 3, 4}}

      iex> parse_ipv4("a.b.c.d", 32)
      :error

      iex> parse_ipv4("1.2.3.4", 64)
      :error
  """
  @spec parse_ipv4(binary, 0..32) :: {:inet.ip4_address(), :inet.ip4_address()} | :error
  def parse_ipv4(address, 32) do
    case Inet.parse_ipv4_binary(address) do
      {:ok, ip4_address} -> {ip4_address, ip4_address}
      _ -> :error
    end
  end

  def parse_ipv4(_, _), do: :error
end
