defmodule EctoIPRange.TestRepo.Migrations.SchemaIP6 do
  use Ecto.Migration

  def change do
    create table("test_schema_ip6", primary_key: false) do
      add :address, :ip6, primary_key: true
    end
  end
end
