defmodule EctoIPRange do
  @moduledoc """
  Ecto/Postgrex types to work with the PostgreSQL
  [`IP4R`](https://github.com/RhodiumToad/ip4r) extension.

  ## Setup

  Define a module with the required `:postgrex` extensions added:

      Postgrex.Types.define(
        MyApp.PostgrexTypes,
        EctoIPRange.Postgrex.extensions() ++ Ecto.Adapters.Postgres.extensions()
      )

  Add this module to your `:ecto` repo configuration:

      config :my_app, MyRepo,
        types: MyApp.PostgrexTypes

  ## Usage

  Define the appropriate field type in your schema:

      defmodule MySchema do
        use Ecto.Schema

        schema "test_schema_ip4" do
          :my_ip_range_field, EctoIPRange.IP4
        end
      end

  The following fields are currently supported:

  - Single Addresses
    - `EctoIPRange.IP4`
    - `EctoIPRange.IP6`
  - Address Ranges
    - `EctoIPRange.IP4R`
    - `EctoIPRange.IP6R`
  """
end
