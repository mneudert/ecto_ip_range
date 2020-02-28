defmodule EctoIPRange.Postgrex.IP4ExtensionTest do
  use EctoIPRange.RepoCase, async: true

  alias EctoIPRange.TestSchemaIP4

  test "ip insert/select" do
    value =
      %TestSchemaIP4{}
      |> Ecto.Changeset.cast(%{address: "1.2.3.4"}, [:address])
      |> Ecto.Changeset.validate_required([:address])
      |> TestRepo.insert!()

    assert [^value] = TestRepo.all(TestSchemaIP4)
  end
end
