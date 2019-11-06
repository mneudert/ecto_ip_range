defmodule EctoIPRange.TestRepo.Migrations.SchemaIP6R do
  use Ecto.Migration

  def change do
    create table("test_schema_ip6r", primary_key: false) do
      add :network, :ip6r, primary_key: true
    end
  end
end
