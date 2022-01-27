defmodule EctoIPRange.Postgrex.IPRangeExtension do
  @moduledoc """
  Postgrex extension for "iprange" fields.
  """

  use Postgrex.BinaryExtension, type: "iprange"

  import Postgrex.BinaryUtils, warn: false

  alias EctoIPRange.{
    IPRange,
    Util.CIDR,
    Util.Inet
  }

  def encode(_) do
    quote location: :keep do
      %IPRange{
        range: range,
        first_ip: {first_a, first_b, first_c, first_d},
        last_ip: {last_a, last_b, last_c, last_d}
      } ->
        case CIDR.parse_mask(range) do
          {:ok, mask} ->
            <<12::int32, 2, mask, 0, 8, first_a, first_b, first_c, first_d, last_a, last_b,
              last_c, last_d>>

          _ ->
            <<12::int32, 2, 255, 0, 8, first_a, first_b, first_c, first_d, last_a, last_b, last_c,
              last_d>>
        end

      %IPRange{
        range: range,
        first_ip: {first_a, first_b, first_c, first_d, first_e, first_f, first_g, first_h},
        last_ip: {last_a, last_b, last_c, last_d, last_e, last_f, last_g, last_h}
      } ->
        <<36::int32, 3, 255, 0, 32, first_a::size(16)-integer-unsigned,
          first_b::size(16)-integer-unsigned, first_c::size(16)-integer-unsigned,
          first_d::size(16)-integer-unsigned, first_e::size(16)-integer-unsigned,
          first_f::size(16)-integer-unsigned, first_g::size(16)-integer-unsigned,
          first_h::size(16)-integer-unsigned, last_a::size(16)-integer-unsigned,
          last_b::size(16)-integer-unsigned, last_c::size(16)-integer-unsigned,
          last_d::size(16)-integer-unsigned, last_e::size(16)-integer-unsigned,
          last_f::size(16)-integer-unsigned, last_g::size(16)-integer-unsigned,
          last_h::size(16)-integer-unsigned>>
    end
  end

  def decode(_) do
    quote location: :keep do
      <<len::int32, data::binary-size(len)>> ->
        unquote(__MODULE__).decode_range(data)
    end
  end

  @doc false
  def decode_range(<<2, bits, _flag, 4, first_a, first_b, first_c, first_d>>) do
    first_ip4_address = {first_a, first_b, first_c, first_d}
    first_address_string = Inet.ntoa(first_ip4_address)
    {cidr_first, cidr_last} = CIDR.parse_ipv4(first_address_string, bits)

    %IPRange{
      range: first_address_string <> "/" <> Integer.to_string(bits),
      first_ip: cidr_first,
      last_ip: cidr_last
    }
  end

  def decode_range(
        <<2, _bits, _flag, 8, first_a, first_b, first_c, first_d, last_a, last_b, last_c, last_d>>
      ) do
    first_ip4_address = {first_a, first_b, first_c, first_d}
    last_ip4_address = {last_a, last_b, last_c, last_d}
    first_address_string = Inet.ntoa(first_ip4_address)
    last_address_string = Inet.ntoa(last_ip4_address)

    %IPRange{
      range: first_address_string <> "-" <> last_address_string,
      first_ip: first_ip4_address,
      last_ip: last_ip4_address
    }
  end

  def decode_range(
        <<3, bits, _flag, 8, first_a::size(16)-integer-unsigned,
          first_b::size(16)-integer-unsigned, first_c::size(16)-integer-unsigned,
          first_d::size(16)-integer-unsigned>>
      ) do
    first_address = {first_a, first_b, first_c, first_d, 0, 0, 0, 0}
    first_address_string = Inet.ntoa(first_address)
    {cidr_first, cidr_last} = CIDR.parse_ipv6(first_address_string, bits)

    %IPRange{
      range: String.downcase(first_address_string) <> "/" <> Integer.to_string(bits),
      first_ip: cidr_first,
      last_ip: cidr_last
    }
  end

  def decode_range(
        <<3, bits, _flag, 16, first_a::size(16)-integer-unsigned,
          first_b::size(16)-integer-unsigned, first_c::size(16)-integer-unsigned,
          first_d::size(16)-integer-unsigned, first_e::size(16)-integer-unsigned,
          first_f::size(16)-integer-unsigned, first_g::size(16)-integer-unsigned,
          first_h::size(16)-integer-unsigned>>
      ) do
    first_address = {first_a, first_b, first_c, first_d, first_e, first_f, first_g, first_h}
    first_address_string = Inet.ntoa(first_address)
    {cidr_first, cidr_last} = CIDR.parse_ipv6(first_address_string, bits)

    %IPRange{
      range: String.downcase(first_address_string) <> "/" <> Integer.to_string(bits),
      first_ip: cidr_first,
      last_ip: cidr_last
    }
  end

  def decode_range(
        <<3, _bits, _flag, 32, first_a::size(16)-integer-unsigned,
          first_b::size(16)-integer-unsigned, first_c::size(16)-integer-unsigned,
          first_d::size(16)-integer-unsigned, first_e::size(16)-integer-unsigned,
          first_f::size(16)-integer-unsigned, first_g::size(16)-integer-unsigned,
          first_h::size(16)-integer-unsigned, last_a::size(16)-integer-unsigned,
          last_b::size(16)-integer-unsigned, last_c::size(16)-integer-unsigned,
          last_d::size(16)-integer-unsigned, last_e::size(16)-integer-unsigned,
          last_f::size(16)-integer-unsigned, last_g::size(16)-integer-unsigned,
          last_h::size(16)-integer-unsigned>>
      ) do
    first_address = {first_a, first_b, first_c, first_d, first_e, first_f, first_g, first_h}
    last_address = {last_a, last_b, last_c, last_d, last_e, last_f, last_g, last_h}
    first_address_string = Inet.ntoa(first_address)
    last_address_string = Inet.ntoa(last_address)

    %IPRange{
      range: String.downcase(first_address_string) <> "-" <> String.downcase(last_address_string),
      first_ip: first_address,
      last_ip: last_address
    }
  end
end
