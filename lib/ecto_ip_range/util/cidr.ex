defmodule EctoIPRange.Util.CIDR do
  @moduledoc false

  import Bitwise

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

      iex> parse_ipv4("1:2:3:4:5:6:7:8", 128)
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

  @doc """
  Calculate first and last address for an IPv6 notation.

  ## Examples

      iex> parse_ipv6("1:2:3:4:5:6:7:8", 128)
      {{1, 2, 3, 4, 5, 6, 7, 8}, {1, 2, 3, 4, 5, 6, 7, 8}}

      iex> parse_ipv6("1:2:3:4::", 110)
      {{1, 2, 3, 4, 0, 0, 0, 0}, {1, 2, 3, 4, 0, 0, 3, 65535}}

      iex> parse_ipv6("1:2:3:4::", 64)
      {{1, 2, 3, 4, 0, 0, 0, 0}, {1, 2, 3, 4, 65535, 65535, 65535, 65535}}

      iex> parse_ipv6("1.2.3.4", 128)
      {{0, 0, 0, 0, 0, 65535, 258, 772}, {0, 0, 0, 0, 0, 65535, 258, 772}}

      iex> parse_ipv6("192.168.0.0", 110)
      {{0, 0, 0, 0, 0, 65535, 49320, 0}, {0, 0, 0, 0, 0, 65535, 49323, 65535}}

      iex> parse_ipv6("1:2:3:4:5:6:7:8", 256)
      :error

      iex> parse_ipv6("1:2:3:4:5:6:7:8", 64)
      :error

      iex> parse_ipv6("s:t:u:v:w:x:y:z", 32)
      :error
  """
  @spec parse_ipv6(binary, 0..128) :: {:inet.ip6_address(), :inet.ip6_address()} | :error
  def parse_ipv6(address, 128) do
    case Inet.parse_ipv6_binary(address) do
      {:ok, ip6_address} -> {ip6_address, ip6_address}
      _ -> :error
    end
  end

  def parse_ipv6(address, maskbits) when maskbits in 0..127 do
    with {:ok, ip6_address} <- Inet.parse_ipv6_binary(address),
         ^ip6_address <- ipv6_start_address(ip6_address, maskbits) do
      {ip6_address, ipv6_end_address(ip6_address, maskbits)}
    else
      _ -> :error
    end
  end

  def parse_ipv6(_, _), do: :error

  def parse_mask(address) do
    with [_address, maskstring] <- String.split(address, "/", parts: 2),
         {maskbits, ""} when maskbits in 0..32 <- Integer.parse(maskstring) do
      {:ok, maskbits}
    else
      _ -> :error
    end
  end

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

  defp ipv6_start_address(
         {start_a, start_b, start_c, start_d, start_e, start_f, start_g, start_h},
         maskbits
       ) do
    {mask_a, mask_b, mask_c, mask_d, mask_e, mask_f, mask_g, mask_h} =
      cond do
        maskbits >= 112 ->
          {0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF,
           bnot(bsr(0xFFFF, maskbits - 112))}

        maskbits >= 96 ->
          {0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, bnot(bsr(0xFFFF, maskbits - 96)), 0}

        maskbits >= 80 ->
          {0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, bnot(bsr(0xFFFF, maskbits - 80)), 0, 0}

        maskbits >= 64 ->
          {0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, bnot(bsr(0xFFFF, maskbits - 64)), 0, 0, 0}

        maskbits >= 48 ->
          {0xFFFF, 0xFFFF, 0xFFFF, bnot(bsr(0xFFFF, maskbits - 48)), 0, 0, 0, 0}

        maskbits >= 32 ->
          {0xFFFF, 0xFFFF, bnot(bsr(0xFFFF, maskbits - 32)), 0, 0, 0, 0, 0}

        maskbits >= 16 ->
          {0xFFFF, bnot(bsr(0xFFFF, maskbits - 16)), 0, 0, 0, 0, 0, 0}

        true ->
          {bnot(bsr(0xFFFF, maskbits)), 0, 0, 0, 0, 0, 0, 0}
      end

    {
      band(mask_a, start_a),
      band(mask_b, start_b),
      band(mask_c, start_c),
      band(mask_d, start_d),
      band(mask_e, start_e),
      band(mask_f, start_f),
      band(mask_g, start_g),
      band(mask_h, start_h)
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

  defp ipv6_end_address(
         {start_a, start_b, start_c, start_d, start_e, start_f, start_g, start_h},
         maskbits
       ) do
    {mask_a, mask_b, mask_c, mask_d, mask_e, mask_f, mask_g, mask_h} =
      cond do
        maskbits >= 112 ->
          {0, 0, 0, 0, 0, 0, 0, bsr(0xFFFF, maskbits - 112)}

        maskbits >= 96 ->
          {0, 0, 0, 0, 0, 0, bsr(0xFFFF, maskbits - 96), 0xFFFF}

        maskbits >= 80 ->
          {0, 0, 0, 0, 0, bsr(0xFFFF, maskbits - 80), 0xFFFF, 0xFFFF}

        maskbits >= 64 ->
          {0, 0, 0, 0, bsr(0xFFFF, maskbits - 64), 0xFFFF, 0xFFFF, 0xFFFF}

        maskbits >= 48 ->
          {0, 0, 0, bsr(0xFFFF, maskbits - 48), 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF}

        maskbits >= 32 ->
          {0, 0, bsr(0xFFFF, maskbits - 32), 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF}

        maskbits >= 16 ->
          {0, bsr(0xFFFF, maskbits - 16), 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF}

        true ->
          {bsr(0xFFFF, maskbits), 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF}
      end

    {
      bor(mask_a, start_a),
      bor(mask_b, start_b),
      bor(mask_c, start_c),
      bor(mask_d, start_d),
      bor(mask_e, start_e),
      bor(mask_f, start_f),
      bor(mask_g, start_g),
      bor(mask_h, start_h)
    }
  end
end
