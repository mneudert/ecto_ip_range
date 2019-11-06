defmodule EctoIPRange.Postgrex.IP6ExtensionTest do
  use EctoIPRange.RepoCase

  alias EctoIPRange.IP6
  alias EctoIPRange.TestSchemaIP6

  test "ip insert/select" do
    {:ok, ip6_address} = IP6.cast("1:2:3:4:5:6:7:8")
    record = %TestSchemaIP6{address: ip6_address}

    assert {:ok, value} = TestRepo.insert(record)
    assert [^value] = TestRepo.all(TestSchemaIP6)
  end
end
