defmodule EctoIPRange.IP4 do
  @moduledoc """
  Struct for PostgreSQL `:ip4`.

  ## Fields

    * `ip`
  """

  use Ecto.Type

  alias EctoIPRange.Util.Inet

  @type t :: %__MODULE__{
          ip: :inet.ip4_address()
        }

  defstruct [:ip]

  @impl Ecto.Type
  def type, do: :ip4

  @impl Ecto.Type
  def cast({_, _, _, _} = ip4_address) do
    case Inet.ntoa(ip4_address) do
      address when is_binary(address) -> {:ok, %__MODULE__{ip: ip4_address}}
      _ -> :error
    end
  end

  def cast(address) when is_binary(address) do
    case Inet.parse_ipv4_binary(address) do
      {:ok, ip4_address} -> {:ok, %__MODULE__{ip: ip4_address}}
      _ -> :error
    end
  end

  def cast(%__MODULE__{} = address), do: {:ok, address}
  def cast(_), do: :error

  @impl Ecto.Type
  def load(%__MODULE__{} = address), do: {:ok, address}
  def load(_), do: :error

  @impl Ecto.Type
  def dump(%__MODULE__{} = address), do: {:ok, address}
  def dump(_), do: :error
end
