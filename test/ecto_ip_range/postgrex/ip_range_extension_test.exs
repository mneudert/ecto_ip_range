defmodule EctoIPRange.Postgrex.IPRangeExtensionTest do
  @moduledoc false

  use EctoIPRange.RepoCase, async: true

  alias EctoIPRange.TestSchemaIPRange

  test "single ip insert/select" do
    value =
      %TestSchemaIPRange{}
      |> Ecto.Changeset.cast(%{network: "1.2.3.4"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIPRange)
  end

  test "cidr /32 insert/select" do
    value =
      %TestSchemaIPRange{}
      |> Ecto.Changeset.cast(%{network: "1.2.3.4/32"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIPRange)
  end

  test "cidr /20 insert/select" do
    value =
      %TestSchemaIPRange{}
      |> Ecto.Changeset.cast(%{network: "192.168.0.0/20"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIPRange)
  end

  test "custom ip range insert/select" do
    value =
      %TestSchemaIPRange{}
      |> Ecto.Changeset.cast(%{network: "1.2.3.4-2.3.4.5"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIPRange)
  end

  test "single ip6 insert/select" do
    value =
      %TestSchemaIPRange{}
      |> Ecto.Changeset.cast(%{network: "1EBF:DB42:96F4:4BFF:9593:41CF:7575:B034"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIPRange)
  end

  test "cidr /24 insert/select" do
    value =
      %TestSchemaIPRange{}
      |> Ecto.Changeset.cast(%{network: "1::/24"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIPRange)
  end

  test "cidr /72 insert/select" do
    value =
      %TestSchemaIPRange{}
      |> Ecto.Changeset.cast(%{network: "1:2:3:4::/72"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIPRange)
  end

  test "cidr /128 insert/select" do
    value =
      %TestSchemaIPRange{}
      |> Ecto.Changeset.cast(%{network: "1:2:3:4:5:6:7:8/128"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIPRange)
  end

  test "custom ip6 range insert/select" do
    value =
      %TestSchemaIPRange{}
      |> Ecto.Changeset.cast(%{network: "1:2:3:4:5:6:7:8-2:3:4:5:6:7:8:9"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIPRange)
  end
end
