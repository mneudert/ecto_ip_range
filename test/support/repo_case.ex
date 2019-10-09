defmodule EctoIPRange.RepoCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox
  alias EctoIPRange.TestRepo

  using do
    quote do
      alias EctoIPRange.TestRepo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import EctoIPRange.RepoCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(TestRepo)

    unless tags[:async] do
      Sandbox.mode(TestRepo, {:shared, self()})
    end

    :ok
  end

  @doc false
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
