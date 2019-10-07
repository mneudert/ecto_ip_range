defmodule EctoIPRange.IP4R do
  @moduledoc """
  Struct für PostgreSQL `:ip4r`.

  ## Fields

    * `cidr`
    * `first_ip`
    * `last_ip`
  """

  use Ecto.Type

  @type t :: %__MODULE__{
          cidr: binary,
          first_ip: :inet.ip4_address(),
          last_ip: :inet.ip4_address()
        }

  defstruct [:cidr, :first_ip, :last_ip]

  def type, do: :ip4r

  def cast(%__MODULE__{} = address), do: {:ok, address}
  def cast(_), do: :error

  def load(_), do: :error

  def dump(_), do: :error
end
