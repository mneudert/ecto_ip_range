defmodule EctoIPRange.IP4RTest do
  use ExUnit.Case, async: true

  alias EctoIPRange.IP4R

  test "cast cidr /32" do
    address = "127.0.0.1/32"
    casted = %IP4R{range: address, first_ip: {127, 0, 0, 1}, last_ip: {127, 0, 0, 1}}

    assert {:ok, ^casted} = IP4R.cast(address)
    assert :error = IP4R.cast("a.b.c.d/32")
  end

  test "error on invalid cidr maskbits" do
    assert :error = IP4R.cast("1.2.3.4/64")
    assert :error = IP4R.cast("1.2.3.4/x")
  end

  test "cast ip4_address" do
    ip4_address = {127, 0, 0, 1}
    casted = %IP4R{range: "127.0.0.1/32", first_ip: ip4_address, last_ip: ip4_address}

    assert {:ok, ^casted} = IP4R.cast(ip4_address)
    assert {:ok, ^casted} = IP4R.cast("127.0.0.1")

    assert :error = IP4R.cast({"a", "b", "c", "d"})
    assert :error = IP4R.cast("a.b.c.d")
  end

  test "cast range" do
    range = "1.1.1.1-2.2.2.2"
    casted = %IP4R{range: range, first_ip: {1, 1, 1, 1}, last_ip: {2, 2, 2, 2}}

    assert {:ok, ^casted} = IP4R.cast(range)
    assert :error = IP4R.cast("1.1.1.1-a.b.c.d")
  end

  test "cast struct" do
    assert {:ok, %IP4R{}} = IP4R.cast(%IP4R{})
    assert :error = IP4R.cast("invalid")
  end

  test "dump" do
    assert {:ok, %IP4R{}} = IP4R.dump(%IP4R{})
    assert :error = IP4R.dump("invalid")
  end

  test "load" do
    assert {:ok, %IP4R{}} = IP4R.load(%IP4R{})
    assert :error = IP4R.load("invalid")
  end
end
