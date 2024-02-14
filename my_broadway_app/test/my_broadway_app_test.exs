defmodule MyBroadwayAppTest do
  use ExUnit.Case
  doctest MyBroadwayApp

  test "greets the world" do
    assert MyBroadwayApp.hello() == :world
  end
end
