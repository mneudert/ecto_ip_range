defmodule EctoIPRange.Postgrex.IP4RExtensionTest do
  use EctoIPRange.RepoCase

  alias EctoIPRange.IP4R
  alias EctoIPRange.TestSchemaIP4R

  test "single ip insert/select" do
    {:ok, network} = IP4R.cast("1.2.3.4")
    record = %TestSchemaIP4R{network: network}

    assert {:ok, value} = TestRepo.insert(record)
    assert [^value] = TestRepo.all(TestSchemaIP4R)
  end

  test "custom ip range insert/select" do
    {:ok, network} = IP4R.cast("1.2.3.4-2.3.4.5")
    record = %TestSchemaIP4R{network: network}

    assert {:ok, value} = TestRepo.insert(record)
    assert [^value] = TestRepo.all(TestSchemaIP4R)
  end
end
