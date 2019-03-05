defmodule MatTest do
  use ExUnit.Case
  alias Bifrost.{
    Mat
  }

  @tag :skip
  test "ping should always return :ok when given a mats pid" do
    {:ok, mat} = Mat.start_link()
    assert Mat.ping(mat) == :ok
  end

  @tag :skip
  test "start_link returns a Mat pid" do
  end

  @tag :skip
  test "Mat.pub adds sends a message to the subscribed processes" do
  end

  @tag :skip
  test "Mat.sub will cause " do
  end

end