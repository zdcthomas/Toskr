defmodule MatTest do
  use ExUnit.Case
  alias Bifrost.{
    Mat
  }

  test "ping should always return :ok when given a mats pid" do
    {:ok, mat} = Mat.start_link()
    assert Mat.ping(mat) == :ok
  end

  test "start_link returns a Mat pid" do
    {:ok, mat} = Mat.start_link()
    assert is_pid(mat)
  end

  test "Mat.pub adds sends a message to the subscribed processes" do
    {:ok, mat} = Mat.start_link()
    message = "message received"
    :ok = Mat.sub(mat, self(), "foo")
    :ok = Mat.pub(mat, "foo", message)
    receive do
      {:msg, received} -> assert message == received
    after
      1000 -> flunk("No callback was received from mock nats") 
    end
  end

end