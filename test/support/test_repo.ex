defmodule EctoIPRange.TestRepo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :ecto_ip_range,
    adapter: Ecto.Adapters.Postgres
end
