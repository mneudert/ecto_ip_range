defmodule EctoIPRange.Util.Range do
  @moduledoc false

  alias EctoIPRange.Util.Inet

  @doc """
  Create a CIDR (if possible) or range notation for two IPv4 tuples.
  """
  @spec parse_ipv4(:inet.ip4_address(), :inet.ip4_address()) :: binary | :error
  def parse_ipv4(ip4_address, ip4_address) do
    case Inet.ntoa(ip4_address) do
      ip when is_binary(ip) -> ip <> "/32"
      _ -> :error
    end
  end

  def parse_ipv4(first_ip4_address, last_ip4_address) do
    with first_ip when is_binary(first_ip) <- Inet.ntoa(first_ip4_address),
         last_ip when is_binary(last_ip) <- Inet.ntoa(last_ip4_address) do
      first_ip <> "-" <> last_ip
    else
      _ -> :error
    end
  end
end
