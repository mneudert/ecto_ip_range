defmodule EctoIPRange.TestSchemaIP4R do
  @moduledoc false

  use Ecto.Schema

  alias EctoIPRange.IP4R

  @primary_key {:network, IP4R, []}

  schema "test_schema_ip4r" do
  end
end
