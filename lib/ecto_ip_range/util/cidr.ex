defmodule EctoIPRange.Util.CIDR do
  @moduledoc false

  use Bitwise, skip_operators: true

  alias EctoIPRange.Util.Inet

  @doc """
  Calculate first and last address for an IPv4 notation.

  ## Examples

      iex> parse_ipv4("1.2.3.4", 32)
      {{1, 2, 3, 4}, {1, 2, 3, 4}}

      iex> parse_ipv4("192.168.0.0", 20)
      {{192, 168, 0, 0}, {192, 168, 15, 255}}

      iex> parse_ipv4("192.168.0.0", 8)
      :error

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

  def parse_ipv4(address, maskbits) when maskbits in 0..31 do
    with {:ok, ip4_address} <- Inet.parse_ipv4_binary(address),
         ^ip4_address <- ipv4_start_address(ip4_address, maskbits) do
      {ip4_address, ipv4_end_address(ip4_address, maskbits)}
    else
      _ -> :error
    end
  end

  def parse_ipv4(_, _), do: :error

  defp ipv4_start_address({start_a, start_b, start_c, start_d}, maskbits) do
    {mask_a, mask_b, mask_c, mask_d} =
      cond do
        maskbits >= 24 -> {0xFF, 0xFF, 0xFF, bnot(bsr(0xFF, maskbits - 24))}
        maskbits >= 16 -> {0xFF, 0xFF, bnot(bsr(0xFF, maskbits - 16)), 0}
        maskbits >= 8 -> {0xFF, bnot(bsr(0xFF, maskbits - 8)), 0, 0}
        true -> {bnot(bsr(0xFF, maskbits)), 0, 0, 0}
      end

    {
      band(mask_a, start_a),
      band(mask_b, start_b),
      band(mask_c, start_c),
      band(mask_d, start_d)
    }
  end

  defp ipv4_end_address({start_a, start_b, start_c, start_d}, maskbits) do
    {mask_a, mask_b, mask_c, mask_d} =
      cond do
        maskbits >= 24 -> {0, 0, 0, bsr(0xFF, maskbits - 24)}
        maskbits >= 16 -> {0, 0, bsr(0xFF, maskbits - 16), 0xFF}
        maskbits >= 8 -> {0, bsr(0xFF, maskbits - 8), 0xFF, 0xFF}
        true -> {bsr(0xFF, maskbits), 0xFF, 0xFF, 0xFF}
      end

    {
      bor(mask_a, start_a),
      bor(mask_b, start_b),
      bor(mask_c, start_c),
      bor(mask_d, start_d)
    }
  end
end
