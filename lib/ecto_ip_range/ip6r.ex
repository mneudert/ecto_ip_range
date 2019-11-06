defmodule EctoIPRange.IP6R do
  @moduledoc """
  Struct für PostgreSQL `:ip6r`.

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
    ip4_address
    |> Inet.ipv4_to_ipv6()
    |> cast()
  end

  def cast({_, _, _, _, _, _, _, _} = ip6_address) do
    case Inet.ntoa(ip6_address) do
      address when is_binary(address) ->
        {:ok,
         %__MODULE__{
           range: address <> "/128",
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
           range: address <> "/128",
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
