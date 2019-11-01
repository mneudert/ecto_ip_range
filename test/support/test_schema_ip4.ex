defmodule EctoIPRange.TestSchemaIP4 do
  @moduledoc false

  use Ecto.Schema

  alias EctoIPRange.IP4

  @primary_key {:address, IP4, []}

  schema "test_schema_ip4" do
  end
end
