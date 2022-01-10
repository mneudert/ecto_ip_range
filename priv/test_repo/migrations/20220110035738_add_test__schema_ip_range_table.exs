defmodule EctoIPRange.TestRepo.Migrations.AddTest_SchemaIpRangeTable do
  use Ecto.Migration

  def change do
    create table("test_schema_ip_range", primary_key: false) do
      add :network, EctoIPRange.IPRange.type(), primary_key: true
    end
  end
end
