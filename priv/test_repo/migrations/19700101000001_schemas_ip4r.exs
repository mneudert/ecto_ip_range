defmodule EctoIPRange.TestRepo.Migrations.SchemaIP4R do
  use Ecto.Migration

  def change do
    create table("test_schema_ip4r", primary_key: false) do
      add :network, EctoIPRange.IP4R.type(), primary_key: true
    end
  end
end
