alias EctoIPRange.TestRepo

TestRepo.start_link()

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(TestRepo, :manual)
