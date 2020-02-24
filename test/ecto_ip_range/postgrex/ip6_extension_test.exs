defmodule EctoIPRange.Postgrex.IP6ExtensionTest do
  use EctoIPRange.RepoCase

  alias EctoIPRange.TestSchemaIP6

  test "ip insert/select" do
    value =
      %TestSchemaIP6{}
      |> Ecto.Changeset.cast(%{address: "1:2:3:4:5:6:7:8"}, [:address])
      |> Ecto.Changeset.validate_required([:address])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIP6)
  end
end
