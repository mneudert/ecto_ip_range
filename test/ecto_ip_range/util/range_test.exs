defmodule EctoIPRange.Util.RangeTest do
  use ExUnit.Case, async: true

  doctest EctoIPRange.Util.Range, import: true

  alias EctoIPRange.Util.Range

  test "parse_ipv4" do
    assert Range.parse_ipv4({0, 0, 0, 0}, {0, 0, 0, 0}) == "0.0.0.0/32"
    assert Range.parse_ipv4({0, 0, 0, 0}, {0, 0, 0, 15}) == "0.0.0.0/28"
    assert Range.parse_ipv4({0, 0, 0, 0}, {0, 0, 0, 255}) == "0.0.0.0/24"
    assert Range.parse_ipv4({0, 0, 0, 0}, {0, 0, 15, 255}) == "0.0.0.0/20"
    assert Range.parse_ipv4({0, 0, 0, 0}, {0, 0, 255, 255}) == "0.0.0.0/16"
    assert Range.parse_ipv4({0, 0, 0, 0}, {0, 15, 255, 255}) == "0.0.0.0/12"
    assert Range.parse_ipv4({0, 0, 0, 0}, {0, 255, 255, 255}) == "0.0.0.0/8"
    assert Range.parse_ipv4({0, 0, 0, 0}, {15, 255, 255, 255}) == "0.0.0.0/4"
    assert Range.parse_ipv4({0, 0, 0, 0}, {255, 255, 255, 255}) == "0.0.0.0/0"
  end
end
