defmodule EctoIPRange.TestRepo.Migrations.SchemaIP4 do
  use Ecto.Migration

  def change do
    create table("test_schema_ip4", primary_key: false) do
      add :address, :ip4, primary_key: true
    end
  end
end
