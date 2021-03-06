defmodule EctoIPRange.Util.RangeTest do
  use ExUnit.Case, async: true

  doctest EctoIPRange.Util.Range, import: true

  alias EctoIPRange.Util.Range

  test "parse_ipv4" do
    [
      {"32", {0, 0, 0, 0}},
      {"28", {0, 0, 0, 15}},
      {"24", {0, 0, 0, 255}},
      {"20", {0, 0, 15, 255}},
      {"16", {0, 0, 255, 255}},
      {"12", {0, 15, 255, 255}},
      {"8", {0, 255, 255, 255}},
      {"4", {15, 255, 255, 255}},
      {"0", {255, 255, 255, 255}}
    ]
    |> Enum.each(fn {maskbits, range_end} ->
      assert "0.0.0.0/" <> ^maskbits = Range.parse_ipv4({0, 0, 0, 0}, range_end)
    end)
  end

  test "parse_ipv6" do
    [
      {"128", {0, 0, 0, 0, 0, 0, 0, 0}},
      {"120", {0, 0, 0, 0, 0, 0, 0, 255}},
      {"112", {0, 0, 0, 0, 0, 0, 0, 65_535}},
      {"104", {0, 0, 0, 0, 0, 0, 255, 65_535}},
      {"96", {0, 0, 0, 0, 0, 0, 65_535, 65_535}},
      {"88", {0, 0, 0, 0, 0, 255, 65_535, 65_535}},
      {"80", {0, 0, 0, 0, 0, 65_535, 65_535, 65_535}},
      {"72", {0, 0, 0, 0, 255, 65_535, 65_535, 65_535}},
      {"64", {0, 0, 0, 0, 65_535, 65_535, 65_535, 65_535}},
      {"56", {0, 0, 0, 255, 65_535, 65_535, 65_535, 65_535}},
      {"48", {0, 0, 0, 65_535, 65_535, 65_535, 65_535, 65_535}},
      {"40", {0, 0, 255, 65_535, 65_535, 65_535, 65_535, 65_535}},
      {"32", {0, 0, 65_535, 65_535, 65_535, 65_535, 65_535, 65_535}},
      {"24", {0, 255, 65_535, 65_535, 65_535, 65_535, 65_535, 65_535}},
      {"16", {0, 65_535, 65_535, 65_535, 65_535, 65_535, 65_535, 65_535}},
      {"8", {255, 65_535, 65_535, 65_535, 65_535, 65_535, 65_535, 65_535}},
      {"0", {65_535, 65_535, 65_535, 65_535, 65_535, 65_535, 65_535, 65_535}}
    ]
    |> Enum.each(fn {maskbits, range_end} ->
      assert "::/" <> ^maskbits = Range.parse_ipv6({0, 0, 0, 0, 0, 0, 0, 0}, range_end)
    end)
  end
end
