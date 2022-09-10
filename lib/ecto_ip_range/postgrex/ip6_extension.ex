defmodule EctoIPRange.Postgrex.IP6Extension do
  @moduledoc """
  `Postgrex` extension for `"ip6"` fields.
  """

  use Postgrex.BinaryExtension, type: "ip6"

  import Postgrex.BinaryUtils, warn: false

  alias EctoIPRange.IP6

  def encode(_) do
    quote location: :keep do
      %IP6{ip: {a, b, c, d, e, f, g, h}} ->
        <<16::int32(), a::int16(), b::int16(), c::int16(), d::int16(), e::int16(), f::int16(),
          g::int16(), h::int16()>>
    end
  end

  def decode(_) do
    quote location: :keep do
      <<16::int32(), a::int16(), b::int16(), c::int16(), d::int16(), e::int16(), f::int16(),
        g::int16(), h::int16()>> ->
        %IP6{ip: {a, b, c, d, e, f, g, h}}
    end
  end
end
