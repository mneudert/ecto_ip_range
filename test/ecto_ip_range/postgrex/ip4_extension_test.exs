defmodule EctoIPRange.Postgrex.IP4ExtensionTest do
  use EctoIPRange.RepoCase

  alias EctoIPRange.IP4
  alias EctoIPRange.TestSchemaIP4

  test "ip insert/select" do
    {:ok, ip4_address} = IP4.cast("1.2.3.4")
    record = %TestSchemaIP4{address: ip4_address}

    assert {:ok, value} = TestRepo.insert(record)
    assert [^value] = TestRepo.all(TestSchemaIP4)
  end
end
