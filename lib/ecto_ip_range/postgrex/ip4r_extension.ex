defmodule EctoIPRange.Postgrex.IP4RExtension do
  @moduledoc """
  Postgrex extension for "ip4r" fields.
  """

  use Postgrex.BinaryExtension, type: "ip4r"

  import Postgrex.BinaryUtils, warn: false

  alias EctoIPRange.IP4R
  alias EctoIPRange.Util.Range

  def encode(_) do
    quote location: :keep do
      %IP4R{
        first_ip: {first_a, first_b, first_c, first_d},
        last_ip: {last_a, last_b, last_c, last_d}
      } ->
        <<8::int32, first_a, first_b, first_c, first_d, last_a, last_b, last_c, last_d>>
    end
  end

  def decode(_) do
    quote location: :keep do
      <<8::int32, first_a, first_b, first_c, first_d, last_a, last_b, last_c, last_d>> ->
        first_ip4_address = {first_a, first_b, first_c, first_d}
        last_ip4_address = {last_a, last_b, last_c, last_d}

        %IP4R{
          range: Range.parse_ipv4(first_ip4_address, last_ip4_address),
          first_ip: first_ip4_address,
          last_ip: last_ip4_address
        }
    end
  end
end
