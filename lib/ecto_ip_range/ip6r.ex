defmodule EctoIPRange.IP6R do
  @moduledoc """
  Struct for PostgreSQL `:ip6r`.

  ## Usage

  When used during a changeset cast the following values are accepted:

  - `:inet.ip6_address()`: an IP6 tuple, e.g. `{8193, 3512, 34211, 0, 0, 35374, 880, 29492}` (single address only)
  - `binary`
    - `"2001:0db8:85a3:0000:0000:8a2e:0370:7334"`: single address
    - `"2001:0db8:85a3:0000:0000:8a2e:0370:0000/112"`: CIDR notation for a range from
      `2001:0db8:85a3:0000:0000:8a2e:0370:0000` to `2001:0db8:85a3:0000:0000:8a2e:0370:ffff`
    - `"2001:0db8:85a3:0000:0000:8a2e:0370:7334-2001:0db8:85a3:0000:0000:8a2e:0370:7335"`: arbitrary range
  - `EctoIPRange.IP4.t()`: a pre-casted struct

  IP4 addresses (binary and tuple) will be converted to IP6 format when casted.

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
          first_ip: :inet.ip6_address(),
          last_ip: :inet.ip6_address()
        }

  defstruct [:range, :first_ip, :last_ip]

  @impl Ecto.Type
  def type, do: :ip6r

  @impl Ecto.Type
  def cast({_, _, _, _} = ip4_address) do
    case Inet.ipv4_to_ipv6(ip4_address) do
      {:ok, ip6_address} -> cast(ip6_address)
      _ -> :error
    end
  end

  def cast({_, _, _, _, _, _, _, _} = ip6_address) do
    case Inet.ntoa(ip6_address) do
      address when is_binary(address) ->
        {:ok,
         %__MODULE__{
           range: String.downcase(address) <> "/128",
           first_ip: ip6_address,
           last_ip: ip6_address
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
    case Inet.parse_ipv6_binary(address) do
      {:ok, ip6_address} ->
        {:ok,
         %__MODULE__{
           range: String.downcase(address) <> "/128",
           first_ip: ip6_address,
           last_ip: ip6_address
         }}

      _ ->
        :error
    end
  end

  defp cast_cidr(cidr) do
    with [address, maskstring] <- String.split(cidr, "/", parts: 2),
         {maskbits, ""} when maskbits in 0..128 <- Integer.parse(maskstring),
         {first_ip6_address, last_ip6_address} <- CIDR.parse_ipv6(address, maskbits) do
      {:ok,
       %__MODULE__{
         range: cidr,
         first_ip: first_ip6_address,
         last_ip: last_ip6_address
       }}
    else
      _ -> :error
    end
  end

  defp cast_range(range) do
    with [first_ip, last_ip] <- String.split(range, "-", parts: 2),
         {:ok, first_ip6_address} <- Inet.parse_ipv6_binary(first_ip),
         {:ok, last_ip6_address} <- Inet.parse_ipv6_binary(last_ip) do
      {:ok,
       %__MODULE__{
         range: range,
         first_ip: first_ip6_address,
         last_ip: last_ip6_address
       }}
    else
      _ -> :error
    end
  end
end
