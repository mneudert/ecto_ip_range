defmodule EctoIPRange.TestSchemaIPRange do
  @moduledoc false

  use Ecto.Schema

  alias EctoIPRange.IPRange

  @primary_key {:network, IPRange, []}

  schema "test_schema_ip_range" do
  end
end
