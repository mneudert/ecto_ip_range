defmodule EctoIPRange.Postgrex.IP4Extension do
  @moduledoc """
  Postgrex extension for "ip4" fields.
  """

  use Postgrex.BinaryExtension, type: "ip4"

  import Postgrex.BinaryUtils, warn: false

  alias EctoIPRange.IP4
  alias EctoIPRange.Util.Inet

  def encode(_) do
    quote location: :keep do
      %IP4{ip: {a, b, c, d}} -> <<4::int32, a, b, c, d>>
    end
  end

  def decode(_) do
    quote location: :keep do
      <<4::int32, a, b, c, d>> -> %IP4{ip: {a, b, c, d}}
    end
  end
end
