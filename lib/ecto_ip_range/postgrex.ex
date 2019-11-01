defmodule EctoIPRange.Postgrex do
  @moduledoc """
  Provides a simple list of available :postgrex extension modules.
  """

  alias EctoIPRange.Postgrex.IP4Extension
  alias EctoIPRange.Postgrex.IP4RExtension

  @doc """
  Returns all available :postgrex extension modules.
  """
  @spec extensions() :: [IP4Extension | IP4RExtension, ...]
  def extensions do
    [IP4Extension, IP4RExtension]
  end
end
