defmodule EctoIPRange.Postgrex do
  @moduledoc """
  Provides a simple list of available `Postgrex` extension modules.
  """

  alias EctoIPRange.Postgrex.{
    IP4Extension,
    IP4RExtension,
    IP6Extension,
    IP6RExtension,
    IPRangeExtension
  }

  @doc """
  Returns all available `Postgrex` extension modules.
  """
  @spec extensions() :: [
          IP4Extension | IP4RExtension | IP6Extension | IP6RExtension | IPRangeExtension,
          ...
        ]
  def extensions do
    [
      IP4Extension,
      IP4RExtension,
      IP6Extension,
      IP6RExtension,
      IPRangeExtension
    ]
  end
end
