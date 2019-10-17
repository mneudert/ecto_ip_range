defmodule EctoIPRange.IP4R do
  @moduledoc """
  Struct für PostgreSQL `:ip4r`.

  ## Fields

    * `range`
    * `first_ip`
    * `last_ip`
  """

  use Ecto.Type

  @type t :: %__MODULE__{
          range: binary,
          first_ip: :inet.ip4_address(),
          last_ip: :inet.ip4_address()
        }

  defstruct [:range, :first_ip, :last_ip]

  def type, do: :ip4r

  def cast({_, _, _, _} = ip_address) do
    case :inet.ntoa(ip_address) do
      address when is_list(address) ->
        {:ok,
         %__MODULE__{
           range: Kernel.to_string(address) <> "/32",
           first_ip: ip_address,
           last_ip: ip_address
         }}

      _ ->
        :error
    end
  end

  def cast(address) when is_binary(address) do
    case String.contains?(address, "-") do
      true -> cast_range(address)
      false -> cast_binary(address)
    end
  end

  def cast(%__MODULE__{} = address), do: {:ok, address}
  def cast(_), do: :error

  def load(_), do: :error

  def dump(_), do: :error

  defp cast_binary(address) do
    case parse_ipv4_binary(address) do
      {:ok, ip_address} ->
        {:ok,
         %__MODULE__{
           range: address <> "/32",
           first_ip: ip_address,
           last_ip: ip_address
         }}

      _ ->
        :error
    end
  end

  defp cast_range(range) do
    with [first_ip, last_ip] <- String.split(range, "-", parts: 2),
         {:ok, first_ip_address} <- parse_ipv4_binary(first_ip),
         {:ok, last_ip_address} <- parse_ipv4_binary(last_ip) do
      {:ok,
       %__MODULE__{
         range: range,
         first_ip: first_ip_address,
         last_ip: last_ip_address
       }}
    else
      _ -> :error
    end
  end

  defp parse_ipv4_binary(address) do
    address
    |> String.to_charlist()
    |> :inet.parse_ipv4_address()
  end
end