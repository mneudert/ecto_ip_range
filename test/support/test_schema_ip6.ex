defmodule EctoIPRange.TestSchemaIP6 do
  @moduledoc false

  use Ecto.Schema

  alias EctoIPRange.IP6

  @primary_key {:address, IP6, []}

  schema "test_schema_ip6" do
  end
end
