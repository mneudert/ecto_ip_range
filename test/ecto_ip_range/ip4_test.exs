defmodule EctoIPRange.IP4Test do
  use ExUnit.Case, async: true

  alias EctoIPRange.IP4

  test "cast ip4_address" do
    ip4_address = {127, 0, 0, 1}
    casted = %IP4{ip: ip4_address}

    assert {:ok, ^casted} = IP4.cast(ip4_address)
    assert {:ok, ^casted} = IP4.cast("127.0.0.1")

    assert :error = IP4.cast({"a", "b", "c", "d"})
    assert :error = IP4.cast("a.b.c.d")
  end

  test "cast struct" do
    assert {:ok, %IP4{}} = IP4.cast(%IP4{})
    assert :error = IP4.cast("invalid")
  end

  test "dump" do
    assert {:ok, %IP4{}} = IP4.dump(%IP4{})
    assert :error = IP4.dump("invalid")
  end

  test "load" do
    assert {:ok, %IP4{}} = IP4.load(%IP4{})
    assert :error = IP4.load("invalid")
  end
end
