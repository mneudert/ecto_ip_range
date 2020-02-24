defmodule EctoIPRange.Postgrex.IP4RExtensionTest do
  use EctoIPRange.RepoCase

  alias EctoIPRange.TestSchemaIP4R

  test "single ip insert/select" do
    value =
      %TestSchemaIP4R{}
      |> Ecto.Changeset.cast(%{network: "1.2.3.4"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIP4R)
  end

  test "cidr /32 insert/select" do
    value =
      %TestSchemaIP4R{}
      |> Ecto.Changeset.cast(%{network: "1.2.3.4/32"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIP4R)
  end

  test "cidr /20 insert/select" do
    value =
      %TestSchemaIP4R{}
      |> Ecto.Changeset.cast(%{network: "192.168.0.0/20"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIP4R)
  end

  test "custom ip range insert/select" do
    value =
      %TestSchemaIP4R{}
      |> Ecto.Changeset.cast(%{network: "1.2.3.4-2.3.4.5"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIP4R)
  end
end
