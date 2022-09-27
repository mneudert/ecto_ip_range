import Config

if Mix.env() == :test do
  alias EctoIPRange.TestRepo

  config :ecto_ip_range, ecto_repos: [TestRepo]

  config :ecto_ip_range, TestRepo,
    username: "postgres",
    password: "postgres",
    database: "ecto_ip_range",
    hostname: "localhost",
    pool: Ecto.Adapters.SQL.Sandbox,
    types: EctoIPRange.PostgrexTypes

  config :logger, level: :warning
end
