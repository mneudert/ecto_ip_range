defmodule EctoIPRange.TestSchemaIP6R do
  @moduledoc false

  use Ecto.Schema

  alias EctoIPRange.IP6R

  @primary_key {:network, IP6R, []}

  schema "test_schema_ip6r" do
  end
end
