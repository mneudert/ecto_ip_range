defmodule EctoIPRange.Util.Range do
  @moduledoc false

  use Bitwise, skip_operators: true

  alias EctoIPRange.Util.Inet

  @doc """
  Create a CIDR (if possible) or range notation for two IPv4 tuples.

  ## Examples

      iex> parse_ipv4({1, 2, 3, 4}, {1, 2, 3, 4})
      "1.2.3.4/32"

      iex> parse_ipv4({127, 0, 0, 0}, {127, 0, 0, 255})
      "127.0.0.0/24"

      iex> parse_ipv4({1, 2, 0, 1}, {1, 2, 0, 0})
      "1.2.0.1-1.2.0.0"

      iex> parse_ipv4({1, 2, 3, 4}, {2, 3, 4, 5})
      "1.2.3.4-2.3.4.5"
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
      case netmask_ipv4(first_ip4_address, last_ip4_address) do
        nil -> first_ip <> "-" <> last_ip
        maskbits -> first_ip <> "/" <> Integer.to_string(maskbits)
      end
    else
      _ -> :error
    end
  end

  @doc """
  Create a CIDR (if possible) or range notation for two IPv6 tuples.

  ## Examples

      iex> parse_ipv6({1, 2, 3, 4, 5, 6, 7, 8}, {1, 2, 3, 4, 5, 6, 7, 8})
      "1:2:3:4:5:6:7:8/128"

      iex> parse_ipv6({1, 2, 3, 4, 0, 0, 0, 0}, {1, 2, 3, 4, 0, 0, 0, 65_535})
      "1:2:3:4::/112"

      iex> parse_ipv6({1, 2, 3, 4, 5, 6, 7, 1}, {1, 2, 3, 4, 5, 6, 7, 0})
      "1:2:3:4:5:6:7:1-1:2:3:4:5:6:7:0"

      iex> parse_ipv6({1, 2, 3, 4, 5, 6, 7, 8}, {2, 3, 4, 5, 6, 7, 8, 9})
      "1:2:3:4:5:6:7:8-2:3:4:5:6:7:8:9"
  """
  @spec parse_ipv6(:inet.ip6_address(), :inet.ip6_address()) :: binary | :error
  def parse_ipv6(ip6_address, ip6_address) do
    case Inet.ntoa(ip6_address) do
      ip when is_binary(ip) -> ip <> "/128"
      _ -> :error
    end
  end

  def parse_ipv6(first_ip6_address, last_ip6_address) do
    with first_ip when is_binary(first_ip) <- Inet.ntoa(first_ip6_address),
         last_ip when is_binary(last_ip) <- Inet.ntoa(last_ip6_address) do
      case netmask_ipv6(first_ip6_address, last_ip6_address) do
        nil -> first_ip <> "-" <> last_ip
        maskbits -> first_ip <> "/" <> Integer.to_string(maskbits)
      end
    else
      _ -> :error
    end
  end

  defp netmask_ipv4({first_a, first_b, first_c, first_d}, {last_a, last_b, last_c, last_d}) do
    netmask_ipv4([first_d, first_c, first_b, first_a], [last_d, last_c, last_b, last_a], 0)
  end

  defp netmask_ipv4([], [], rangebits), do: 32 - rangebits
  defp netmask_ipv4([first | _], [first | _], rangebits), do: 32 - rangebits

  defp netmask_ipv4([first | first_parts], [last | last_parts], rangebits) do
    partbits =
      Enum.reduce_while(0..7, 0, fn bit, acc ->
        first_bit = band(first, bsl(1, bit))
        last_bit = band(last, bsl(1, bit))

        cond do
          0 == first_bit and 0 != last_bit -> {:cont, acc + 1}
          bsr(first_bit, bit) == bsr(last_bit, bit) -> {:halt, acc}
          true -> {:halt, nil}
        end
      end)

    cond do
      partbits == nil -> nil
      partbits == 8 -> netmask_ipv4(first_parts, last_parts, rangebits + partbits)
      first_parts == last_parts -> 32 - (rangebits + partbits)
      true -> nil
    end
  end

  defp netmask_ipv6(
         {first_a, first_b, first_c, first_d, first_e, first_f, first_g, first_h},
         {last_a, last_b, last_c, last_d, last_e, last_f, last_g, last_h}
       ) do
    netmask_ipv6(
      [first_h, first_g, first_f, first_e, first_d, first_c, first_b, first_a],
      [last_h, last_g, last_f, last_e, last_d, last_c, last_b, last_a],
      0
    )
  end

  defp netmask_ipv6([], [], rangebits), do: 128 - rangebits
  defp netmask_ipv6([first | _], [first | _], rangebits), do: 128 - rangebits

  defp netmask_ipv6([first | first_parts], [last | last_parts], rangebits) do
    partbits =
      Enum.reduce_while(0..15, 0, fn bit, acc ->
        first_bit = band(first, bsl(1, bit))
        last_bit = band(last, bsl(1, bit))

        cond do
          0 == first_bit and 0 != last_bit -> {:cont, acc + 1}
          bsr(first_bit, bit) == bsr(last_bit, bit) -> {:halt, acc}
          true -> {:halt, nil}
        end
      end)

    cond do
      partbits == nil -> nil
      partbits == 16 -> netmask_ipv6(first_parts, last_parts, rangebits + partbits)
      first_parts == last_parts -> 128 - (rangebits + partbits)
      true -> nil
    end
  end
end
