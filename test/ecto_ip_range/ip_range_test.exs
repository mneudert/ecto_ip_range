defmodule EctoIPRange.IPRangeTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias EctoIPRange.IPRange

  test "cast cidr /32" do
    address = "127.0.0.1/32"
    casted = %IPRange{range: address, first_ip: {127, 0, 0, 1}, last_ip: {127, 0, 0, 1}}

    assert {:ok, ^casted} = IPRange.cast(address)
    assert :error = IPRange.cast("a.b.c.d/32")
  end

  test "cast cidr ipv6/128" do
    address = "1:2:3:4:5:6:7:8/128"

    casted = %IPRange{
      range: address,
      first_ip: {1, 2, 3, 4, 5, 6, 7, 8},
      last_ip: {1, 2, 3, 4, 5, 6, 7, 8}
    }

    assert {:ok, ^casted} = IPRange.cast(address)
    assert :error = IPRange.cast("s:t:u:v:w:x:y:z/128")
  end

  test "error on invalid cidr maskbits" do
    assert :error = IPRange.cast("1:2:3:4:5:6:7:8/256")
    assert :error = IPRange.cast("1.2.3.4/x")
    assert :error = IPRange.cast("1:2:3:4:5:6:7:8/XX")
  end

  test "cast ip4_address" do
    ip4_address = {127, 0, 0, 1}
    casted = %IPRange{range: "127.0.0.1/32", first_ip: ip4_address, last_ip: ip4_address}

    assert {:ok, ^casted} = IPRange.cast(ip4_address)
    assert {:ok, ^casted} = IPRange.cast("127.0.0.1")

    assert :error = IPRange.cast({"a", "b", "c", "d"})
    assert :error = IPRange.cast("a.b.c.d")
  end

  test "cast ip6_address" do
    ip6_address = {7871, 56_130, 38_644, 19_455, 38_291, 16_847, 30_069, 45_108}

    casted = %IPRange{
      range: "1ebf:db42:96f4:4bff:9593:41cf:7575:b034/128",
      first_ip: ip6_address,
      last_ip: ip6_address
    }

    assert {:ok, ^casted} = IPRange.cast(ip6_address)
    assert {:ok, ^casted} = IPRange.cast("1EBF:DB42:96F4:4BFF:9593:41CF:7575:B034")

    assert :error = IPRange.cast({"s", "t", "u", "v", "w", "x", "y", "z"})
    assert :error = IPRange.cast("s:t:u:v:w:x:y:z")
  end

  test "cast ip4 range" do
    range = "1.1.1.1-2.2.2.2"
    casted = %IPRange{range: range, first_ip: {1, 1, 1, 1}, last_ip: {2, 2, 2, 2}}

    assert {:ok, ^casted} = IPRange.cast(range)
    assert :error = IPRange.cast("1.1.1.1-a.b.c.d")
  end

  test "cast struct" do
    assert {:ok, %IPRange{}} = IPRange.cast(%IPRange{})
    assert :error = IPRange.cast("invalid")
  end

  test "dump" do
    assert {:ok, %IPRange{}} = IPRange.dump(%IPRange{})
    assert :error = IPRange.dump("invalid")
  end

  test "load" do
    assert {:ok, %IPRange{}} = IPRange.load(%IPRange{})
    assert :error = IPRange.load("invalid")
  end
end
