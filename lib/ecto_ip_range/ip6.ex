defmodule EctoIPRange.IP6 do
  @moduledoc """
  Struct für PostgreSQL `:ip6`.

  ## Fields

    * `ip`
  """

  use Ecto.Type

  alias EctoIPRange.Util.Inet

  @type t :: %__MODULE__{
          ip: :inet.ip6_address()
        }

  defstruct [:ip]

  @impl Ecto.Type
  def type, do: :ip6

  @impl Ecto.Type
  def cast({_, _, _, _} = ip4_address) do
    case Inet.ipv4_to_ipv6(ip4_address) do
      {:ok, ip6_address} -> cast(ip6_address)
      _ -> :error
    end
  end

  def cast({_, _, _, _, _, _, _, _} = ip6_address) do
    case Inet.ntoa(ip6_address) do
      address when is_binary(address) -> {:ok, %__MODULE__{ip: ip6_address}}
      _ -> :error
    end
  end

  def cast(address) when is_binary(address) do
    case Inet.parse_ipv6_binary(address) do
      {:ok, ip6_address} -> {:ok, %__MODULE__{ip: ip6_address}}
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
