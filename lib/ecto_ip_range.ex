defmodule EctoIPRange do
  @moduledoc """
  ## Setup

  Define a module with the required `:postgrex` extensions added:

      Postgrex.Types.define(
        MyApp.PostgrexTypes,
        EctoIPRange.Postgrex.extensions() ++ Ecto.Adapters.Postgres.extensions()
      )

  Add this module to your `:ecto` repo configuration:

      config :my_app, MyRepo,
        types: MyApp.PostgrexTypes
  """
end
