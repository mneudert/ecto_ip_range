defmodule EctoIPRange.IP4RTest do
  use ExUnit.Case, async: true

  alias EctoIPRange.IP4R

  test "cast ip_address" do
    ip_address = {127, 0, 0, 1}
    casted = %IP4R{range: "127.0.0.1/32", first_ip: ip_address, last_ip: ip_address}

    assert {:ok, ^casted} = IP4R.cast(ip_address)
    assert {:ok, ^casted} = IP4R.cast("127.0.0.1")

    assert IP4R.cast({"a", "b", "c", "d"}) == :error
    assert IP4R.cast("a.b.c.d") == :error
  end

  test "cast struct" do
    assert {:ok, %IP4R{}} = IP4R.cast(%IP4R{})
    assert IP4R.cast("invalid") == :error
  end

  test "dump" do
    assert IP4R.dump("invalid") == :error
  end

  test "load" do
    assert IP4R.load("invalid") == :error
  end
end
