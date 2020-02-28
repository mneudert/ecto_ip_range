defmodule EctoIPRange.Postgrex.IP6RExtensionTest do
  use EctoIPRange.RepoCase, async: true

  alias EctoIPRange.TestSchemaIP6R

  test "single ip insert/select" do
    value =
      %TestSchemaIP6R{}
      |> Ecto.Changeset.cast(%{network: "1:2:3:4:5:6:7:8"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIP6R)
  end

  test "cidr /128 insert/select" do
    value =
      %TestSchemaIP6R{}
      |> Ecto.Changeset.cast(%{network: "1:2:3:4:5:6:7:8/128"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIP6R)
  end

  test "cidr /72 insert/select" do
    value =
      %TestSchemaIP6R{}
      |> Ecto.Changeset.cast(%{network: "1:2:3:4::/72"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIP6R)
  end

  test "custom ip range insert/select" do
    value =
      %TestSchemaIP6R{}
      |> Ecto.Changeset.cast(%{network: "1:2:3:4:5:6:7:8-2:3:4:5:6:7:8:9"}, [:network])
      |> Ecto.Changeset.validate_required([:network])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIP6R)
  end
end
