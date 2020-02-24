defmodule EctoIPRange.IP4R do
  @moduledoc """
  Struct for PostgreSQL `:ip4r`.

  ## Usage

  When used during a changeset cast the following values are accepted:

  - `:inet.ip4_address()`: an IP4 tuple, e.g. `{127, 0, 0, 1}` (single address only)
  - `binary`
    - `"127.0.0.1"`: single address
    - `"127.0.0.0/24"`: CIDR notation for a range from `127.0.0.0` to `127.0.0.255`
    - `"127.0.0.1-127.0.0.2"`: arbitrary range
  - `EctoIPRange.IP4R.t()`: a pre-casted struct

  ## Fields

    * `range`
    * `first_ip`
    * `last_ip`
  """

  use Ecto.Type

  alias EctoIPRange.Util.CIDR
  alias EctoIPRange.Util.Inet

  @type t :: %__MODULE__{
          range: binary,
          first_ip: :inet.ip4_address(),
          last_ip: :inet.ip4_address()
        }

  defstruct [:range, :first_ip, :last_ip]

  @impl Ecto.Type
  def type, do: :ip4r

  @impl Ecto.Type
  def cast({_, _, _, _} = ip4_address) do
    case Inet.ntoa(ip4_address) do
      address when is_binary(address) ->
        {:ok,
         %__MODULE__{
           range: address <> "/32",
           first_ip: ip4_address,
           last_ip: ip4_address
         }}

      _ ->
        :error
    end
  end

  def cast(address) when is_binary(address) do
    cond do
      String.contains?(address, "-") -> cast_range(address)
      String.contains?(address, "/") -> cast_cidr(address)
      true -> cast_binary(address)
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

  defp cast_binary(address) do
    case Inet.parse_ipv4_binary(address) do
      {:ok, ip4_address} ->
        {:ok,
         %__MODULE__{
           range: address <> "/32",
           first_ip: ip4_address,
           last_ip: ip4_address
         }}

      _ ->
        :error
    end
  end

  defp cast_cidr(cidr) do
    with [address, maskstring] <- String.split(cidr, "/", parts: 2),
         {maskbits, ""} when maskbits in 0..32 <- Integer.parse(maskstring),
         {first_ip4_address, last_ip4_address} <- CIDR.parse_ipv4(address, maskbits) do
      {:ok,
       %__MODULE__{
         range: cidr,
         first_ip: first_ip4_address,
         last_ip: last_ip4_address
       }}
    else
      _ -> :error
    end
  end

  defp cast_range(range) do
    with [first_ip, last_ip] <- String.split(range, "-", parts: 2),
         {:ok, first_ip4_address} <- Inet.parse_ipv4_binary(first_ip),
         {:ok, last_ip4_address} <- Inet.parse_ipv4_binary(last_ip) do
      {:ok,
       %__MODULE__{
         range: range,
         first_ip: first_ip4_address,
         last_ip: last_ip4_address
       }}
    else
      _ -> :error
    end
  end
end
