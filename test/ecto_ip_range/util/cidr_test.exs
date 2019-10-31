defmodule EctoIPRange.Util.CIDRTest do
  use ExUnit.Case, async: true

  doctest EctoIPRange.Util.CIDR, import: true

  alias EctoIPRange.Util.CIDR

  test "parse_ipv4" do
    assert CIDR.parse_ipv4("0.0.0.0", 32) == {{0, 0, 0, 0}, {0, 0, 0, 0}}
    assert CIDR.parse_ipv4("0.0.0.0", 28) == {{0, 0, 0, 0}, {0, 0, 0, 15}}
    assert CIDR.parse_ipv4("0.0.0.0", 24) == {{0, 0, 0, 0}, {0, 0, 0, 255}}
    assert CIDR.parse_ipv4("0.0.0.0", 20) == {{0, 0, 0, 0}, {0, 0, 15, 255}}
    assert CIDR.parse_ipv4("0.0.0.0", 16) == {{0, 0, 0, 0}, {0, 0, 255, 255}}
    assert CIDR.parse_ipv4("0.0.0.0", 12) == {{0, 0, 0, 0}, {0, 15, 255, 255}}
    assert CIDR.parse_ipv4("0.0.0.0", 8) == {{0, 0, 0, 0}, {0, 255, 255, 255}}
    assert CIDR.parse_ipv4("0.0.0.0", 4) == {{0, 0, 0, 0}, {15, 255, 255, 255}}
    assert CIDR.parse_ipv4("0.0.0.0", 0) == {{0, 0, 0, 0}, {255, 255, 255, 255}}
  end
end
