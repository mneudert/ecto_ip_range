defmodule EctoIPRange.IP6Test do
  use ExUnit.Case, async: true

  alias EctoIPRange.IP6

  test "cast ip4_address" do
    casted = %IP6{ip: {0, 0, 0, 0, 0, 65_535, 32_512, 1}}

    assert {:ok, ^casted} = IP6.cast({127, 0, 0, 1})
    assert {:ok, ^casted} = IP6.cast("127.0.0.1")

    assert :error = IP6.cast({"a", "b", "c", "d"})
    assert :error = IP6.cast("a.b.c.d")
  end

  test "cast ip6_address" do
    ip6_address = {1, 2, 3, 4, 5, 6, 7, 8}
    casted = %IP6{ip: ip6_address}

    assert {:ok, ^casted} = IP6.cast(ip6_address)
    assert {:ok, ^casted} = IP6.cast("1:2:3:4:5:6:7:8")

    assert :error = IP6.cast({"s", "t", "u", "v", "w", "x", "y", "z"})
    assert :error = IP6.cast("s:t:u:v:w:x:y:z")
  end

  test "cast struct" do
    assert {:ok, %IP6{}} = IP6.cast(%IP6{})
    assert :error = IP6.cast("invalid")
  end

  test "dump" do
    assert {:ok, %IP6{}} = IP6.dump(%IP6{})
    assert :error = IP6.dump("invalid")
  end

  test "load" do
    assert {:ok, %IP6{}} = IP6.load(%IP6{})
    assert :error = IP6.load("invalid")
  end
end
