defmodule EctoIPRange.Postgrex.IP6RExtension do
  @moduledoc """
  `Postgrex` extension for `"ip6r"` fields.
  """

  use Postgrex.BinaryExtension, type: "ip6r"

  import Postgrex.BinaryUtils, warn: false

  alias EctoIPRange.IP6R
  alias EctoIPRange.Util.Range

  def encode(_) do
    quote location: :keep do
      %IP6R{
        first_ip: {first_a, first_b, first_c, first_d, first_e, first_f, first_g, first_h},
        last_ip: {last_a, last_b, last_c, last_d, last_e, last_f, last_g, last_h}
      } ->
        <<32::int32(), first_a::size(16)-integer-unsigned, first_b::size(16)-integer-unsigned,
          first_c::size(16)-integer-unsigned, first_d::size(16)-integer-unsigned,
          first_e::size(16)-integer-unsigned, first_f::size(16)-integer-unsigned,
          first_g::size(16)-integer-unsigned, first_h::size(16)-integer-unsigned,
          last_a::size(16)-integer-unsigned, last_b::size(16)-integer-unsigned,
          last_c::size(16)-integer-unsigned, last_d::size(16)-integer-unsigned,
          last_e::size(16)-integer-unsigned, last_f::size(16)-integer-unsigned,
          last_g::size(16)-integer-unsigned, last_h::size(16)-integer-unsigned>>
    end
  end

  def decode(_) do
    quote location: :keep do
      <<32::int32(), first_a::size(16)-integer-unsigned, first_b::size(16)-integer-unsigned,
        first_c::size(16)-integer-unsigned, first_d::size(16)-integer-unsigned,
        first_e::size(16)-integer-unsigned, first_f::size(16)-integer-unsigned,
        first_g::size(16)-integer-unsigned, first_h::size(16)-integer-unsigned,
        last_a::size(16)-integer-unsigned, last_b::size(16)-integer-unsigned,
        last_c::size(16)-integer-unsigned, last_d::size(16)-integer-unsigned-unsigned,
        last_e::size(16)-integer-unsigned, last_f::size(16)-integer-unsigned,
        last_g::size(16)-integer-unsigned, last_h::size(16)-integer-unsigned>> ->
        first_ip6_address =
          {first_a, first_b, first_c, first_d, first_e, first_f, first_g, first_h}

        last_ip6_address = {last_a, last_b, last_c, last_d, last_e, last_f, last_g, last_h}

        %IP6R{
          range: Range.parse_ipv6(first_ip6_address, last_ip6_address),
          first_ip: first_ip6_address,
          last_ip: last_ip6_address
        }
    end
  end
end
