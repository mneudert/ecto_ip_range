defmodule EctoIPRange.Util.Inet do
  @moduledoc false

  @doc """
  Convert an IPv4 tuple into an IPv6 tuple.

  Wrapper around `:inet.ipv4_mapped_ipv6_address/1` to allow only IPv4-to-IPv6
  conversion and provide support for OTP < 21.

  ## Examples

      iex> ipv4_to_ipv6({127, 0, 0, 1})
      {0, 0, 0, 0, 0, 65_535, 32_512, 1}

      iex> ipv4_to_ipv6({512, 0, 0, 1})
      {:error, :einval}

      iex> ipv4_to_ipv6({"a", "b", "c", "d"})
      {:error, :einval}

      iex ipv4_to_ipv6({0, 0, 0, 0, 0, 65_535, 32_512, 1})
      {:error, :einval}
  """
  @spec ipv4_to_ipv6(:inet.ip4_address()) :: :inet.ip6_address() | {:error, :einval}

  if function_exported?(:inet, :ipv4_mapped_ipv6_address, 1) do
    def ipv4_to_ipv6({a, b, c, d} = ip4_address)
        when a in 0..255 and b in 0..255 and c in 0..255 and d in 0..255 do
      :inet.ipv4_mapped_ipv6_address(ip4_address)
    end
  else
    def ipv4_to_ipv6({a, b, c, d} = ip4_address)
        when a in 0..255 and b in 0..255 and c in 0..255 and d in 0..255 do
      ip4_address
      |> :inet.ntoa()
      |> :inet.parse_ipv6_address()
    end
  end

  def ipv4_to_ipv6(_), do: {:error, :einval}

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
  Parse a binary IPv4 or IPv6 address.

  ## Examples

      iex> parse_binary("1.2.3.4")
      {:ok, {1, 2, 3, 4}}

      iex> parse_binary("1:2:3:4:5:6:7:8")
      {:ok, {1, 2, 3, 4, 5, 6, 7, 8}}

      iex> parse_binary("a.b.c.d")
      {:error, :einval}

      iex> parse_binary("s:t:u:v:w:x:y:z")
      {:error, :einval}
  """
  @spec parse_binary(binary) :: {:ok, :inet.ip_address()} | {:error, :einval}
  def parse_binary(address) do
    address
    |> String.to_charlist()
    |> :inet.parse_address()
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
