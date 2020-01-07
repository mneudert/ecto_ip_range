defmodule EctoIPRange.Postgrex.IP6RExtensionTest do
  use EctoIPRange.RepoCase

  alias EctoIPRange.IP6R
  alias EctoIPRange.TestSchemaIP6R

  test "single ip insert/select" do
    {:ok, network} = IP6R.cast("1:2:3:4:5:6:7:8")
    record = %TestSchemaIP6R{network: network}

    assert {:ok, value} = TestRepo.insert(record)
    assert [^value] = TestRepo.all(TestSchemaIP6R)
  end

  test "cidr /128 insert/select" do
    {:ok, network} = IP6R.cast("1:2:3:4:5:6:7:8/128")
    record = %TestSchemaIP6R{network: network}

    assert {:ok, value} = TestRepo.insert(record)
    assert [^value] = TestRepo.all(TestSchemaIP6R)
  end

  test "cidr /72 insert/select" do
    {:ok, network} = IP6R.cast("1:2:3:4::/72")
    record = %TestSchemaIP6R{network: network}

    assert {:ok, value} = TestRepo.insert(record)
    assert [^value] = TestRepo.all(TestSchemaIP6R)
  end

  test "custom ip range insert/select" do
    {:ok, network} = IP6R.cast("1:2:3:4:5:6:7:8-2:3:4:5:6:7:8:9")
    record = %TestSchemaIP6R{network: network}

    assert {:ok, value} = TestRepo.insert(record)
    assert [^value] = TestRepo.all(TestSchemaIP6R)
  end
end
