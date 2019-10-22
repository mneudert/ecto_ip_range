defmodule EctoIPRange.Postgrex.IP4RExtension do
  @moduledoc """
  Postgrex extension for "ip4r" fields.
  """

  use Postgrex.BinaryExtension, type: "ip4r"

  import Postgrex.BinaryUtils, warn: false

  alias EctoIPRange.IP4R
  alias EctoIPRange.Util.Inet

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
      <<8::int32, first_a, first_b, first_c, first_d, first_a, first_b, first_c, first_d>> ->
        first_ip_address = {first_a, first_b, first_c, first_d}

        with first_ip when is_binary(first_ip) <- Inet.ntoa(first_ip_address) do
          %IP4R{
            range: first_ip <> "/32",
            first_ip: first_ip_address,
            last_ip: first_ip_address
          }
        end

      <<8::int32, first_a, first_b, first_c, first_d, last_a, last_b, last_c, last_d>> ->
        first_ip_address = {first_a, first_b, first_c, first_d}
        last_ip_address = {last_a, last_b, last_c, last_d}

        with(
          first_ip when is_binary(first_ip) <- Inet.ntoa(first_ip_address),
          last_ip when is_binary(last_ip) <- Inet.ntoa(last_ip_address)
        ) do
          %IP4R{
            range: first_ip <> "-" <> last_ip,
            first_ip: first_ip_address,
            last_ip: last_ip_address
          }
        end
    end
  end
end
