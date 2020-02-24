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

  ### Migrations

  To use the fields in migrations you need to either access the underlying
  type atom or specify the type atom directly:

      defmodule MyRepo.Migration do
        use Ecto.Migration

        def change do
          create table("my_table") do
            add :direct, :ip4r
            add :underlying, EctoIPRange.IP4R.type()
          end
        end
      end

  ### Changesets

  To insert a database record with an IP range field you need to ensure the
  internal type is properly casted. For example using a changeset:

      %MySchema{}
      |> Ecto.Changeset.cast(%{ip4_address: "1.2.3.4"}, [:ip4_address])
      |> Ecto.Changeset.validate_required([:ip4_address])
      |> MyRepo.insert!()

  Please refer to the individual types to see what values are accepted.
  """
end
