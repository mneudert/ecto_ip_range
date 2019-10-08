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

  def cast(%__MODULE__{} = address), do: {:ok, address}
  def cast(_), do: :error

  def load(_), do: :error

  def dump(_), do: :error
end
