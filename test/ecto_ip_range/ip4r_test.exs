defmodule EctoIPRange.IP4RTest do
  use ExUnit.Case, async: true

  alias EctoIPRange.IP4R

  test "cast" do
    assert {:ok, %IP4R{}} = IP4R.cast(%IP4R{})
    assert IP4R.cast("invalid") == :error
  end

  test "dump" do
    assert IP4R.dump("invalid") == :error
  end

  test "load" do
    assert IP4R.load("invalid") == :error
  end
end
