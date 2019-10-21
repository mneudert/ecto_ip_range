defmodule EctoIPRange.Util.Inet do
  @moduledoc false

  @doc """
  Convert an IP tuple to a binary address.
  """
  @spec ntoa(:inet.ip_address()) :: binary | nil
  def ntoa(ip_address) do
    case :inet.ntoa(ip_address) do
      address when is_list(address) -> Kernel.to_string(address)
      _ -> nil
    end
  end

  @doc """
  Parse a binary IPv4 address.
  """
  @spec parse_ipv4_binary(binary) :: {:ok, :inet.ip_address()} | {:error, :einval}
  def parse_ipv4_binary(address) do
    address
    |> String.to_charlist()
    |> :inet.parse_ipv4_address()
  end
end
