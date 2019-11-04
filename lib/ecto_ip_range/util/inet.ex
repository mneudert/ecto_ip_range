defmodule EctoIPRange.Util.Inet do
  @moduledoc false

  @doc """
  Convert an IP tuple to a binary address.

  ## Examples

      iex> ntoa({1, 2, 3, 4})
      "1.2.3.4"

      iex> ntoa({1, 2, 3, 4, 5, 6, 7, 8})
      "1:2:3:4:5:6:7:8"

      iex> ntoa("1.2.3.4")
      nil

      iex> ntoa("a.b.c.d")
      nil
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

  ## Examples

      iex> parse_ipv4_binary("1.2.3.4")
      {:ok, {1, 2, 3, 4}}

      iex> parse_ipv4_binary("1:2:3:4:5:6:7:8")
      {:error, :einval}

      iex> parse_ipv4_binary("a.b.c.d")
      {:error, :einval}

      iex> parse_ipv4_binary("s:t:u:v:w:x:y:z")
      {:error, :einval}
  """
  @spec parse_ipv4_binary(binary) :: {:ok, :inet.ip4_address()} | {:error, :einval}
  def parse_ipv4_binary(address) do
    address
    |> String.to_charlist()
    |> :inet.parse_ipv4_address()
  end

  @doc """
  Parse a binary IPv6 address.

  ## Examples

      iex> parse_ipv6_binary("1.2.3.4")
      {:ok, {0, 0, 0, 0, 0, 65535, 258, 772}}

      iex> parse_ipv6_binary("1:2:3:4:5:6:7:8")
      {:ok, {1, 2, 3, 4, 5, 6, 7, 8}}

      iex> parse_ipv6_binary("a.b.c.d")
      {:error, :einval}

      iex> parse_ipv6_binary("s:t:u:v:w:x:y:z")
      {:error, :einval}
  """
  @spec parse_ipv6_binary(binary) :: {:ok, :inet.ip6_address()} | {:error, :einval}
  def parse_ipv6_binary(address) do
    address
    |> String.to_charlist()
    |> :inet.parse_ipv6_address()
  end
end
