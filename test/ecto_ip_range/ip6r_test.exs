defmodule EctoIPRange.IP6RTest do
  use ExUnit.Case, async: true

  alias EctoIPRange.IP6R

  test "cast cidr ipv4/128" do
    address = "127.0.0.1/128"

    casted = %IP6R{
      range: address,
      first_ip: {0, 0, 0, 0, 0, 65_535, 32_512, 1},
      last_ip: {0, 0, 0, 0, 0, 65_535, 32_512, 1}
    }

    assert {:ok, ^casted} = IP6R.cast(address)
    assert :error = IP6R.cast("a.b.c.d/128")
  end

  test "cast cidr ipv6/128" do
    address = {7871, 56_130, 38_644, 19_455, 38_291, 16_847, 30_069, 45_108}

    casted = %IP6R{
      range: "1ebf:db42:96f4:4bff:9593:41cf:7575:b034/128",
      first_ip: address,
      last_ip: address
    }

    assert {:ok, ^casted} = IP6R.cast(address)
    assert {:ok, ^casted} = IP6R.cast("1EBF:DB42:96F4:4BFF:9593:41CF:7575:B034")

    assert {:ok, ^casted} = IP6R.cast(address)
    assert :error = IP6R.cast("s:t:u:v:w:x:y:z/128")
  end

  test "error on invalid cidr maskbits" do
    assert :error = IP6R.cast("1:2:3:4:5:6:7:8/256")
    assert :error = IP6R.cast("1:2:3:4:5:6:7:8/XX")
  end

  test "cast ip4_address" do
    ip4_address = {127, 0, 0, 1}

    casted_address = %IP6R{
      first_ip: {0, 0, 0, 0, 0, 65_535, 32_512, 1},
      last_ip: {0, 0, 0, 0, 0, 65_535, 32_512, 1}
    }

    casted_address =
      case System.otp_release() do
        "19" -> %{casted_address | range: "::FFFF:127.0.0.1/128"}
        _ -> %{casted_address | range: "::ffff:127.0.0.1/128"}
      end

    casted_binary = %{casted_address | range: "127.0.0.1/128"}

    assert {:ok, ^casted_address} = IP6R.cast(ip4_address)
    assert {:ok, ^casted_binary} = IP6R.cast("127.0.0.1")

    assert :error = IP6R.cast({"a", "b", "c", "d"})
    assert :error = IP6R.cast("a.b.c.d")
  end

  test "cast ip6_address" do
    ip6_address = {1, 2, 3, 4, 5, 6, 7, 8}
    casted = %IP6R{range: "1:2:3:4:5:6:7:8/128", first_ip: ip6_address, last_ip: ip6_address}

    assert {:ok, ^casted} = IP6R.cast(ip6_address)
    assert {:ok, ^casted} = IP6R.cast("1:2:3:4:5:6:7:8")

    assert :error = IP6R.cast({"s", "t", "u", "v", "w", "x", "y", "z"})
    assert :error = IP6R.cast("s:t:u:v:w:x:y:z")
  end

  test "cast ipv4 range" do
    range = "1.1.1.1-2.2.2.2"

    casted = %IP6R{
      range: range,
      first_ip: {0, 0, 0, 0, 0, 65_535, 257, 257},
      last_ip: {0, 0, 0, 0, 0, 65_535, 514, 514}
    }

    assert {:ok, ^casted} = IP6R.cast(range)
    assert :error = IP6R.cast("1.1.1.1-a.b.c.d")
  end

  test "cast ipv6 range" do
    range = "1:2:3:4:5:6:7:8-2:3:4:5:6:7:8:9"

    casted = %IP6R{
      range: range,
      first_ip: {1, 2, 3, 4, 5, 6, 7, 8},
      last_ip: {2, 3, 4, 5, 6, 7, 8, 9}
    }

    assert {:ok, ^casted} = IP6R.cast(range)
    assert :error = IP6R.cast("1:2:3:4:5:6:7:8-s:t:u:v:w:x:y:z")
  end

  test "cast struct" do
    assert {:ok, %IP6R{}} = IP6R.cast(%IP6R{})
    assert :error = IP6R.cast("invalid")
  end

  test "dump" do
    assert {:ok, %IP6R{}} = IP6R.dump(%IP6R{})
    assert :error = IP6R.dump("invalid")
  end

  test "load" do
    assert {:ok, %IP6R{}} = IP6R.load(%IP6R{})
    assert :error = IP6R.load("invalid")
  end
end
