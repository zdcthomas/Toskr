defmodule Toskr.Mat do
  @moduledoc """
  This module mocks out the `Gnat` module's behaviour, to avoid any outgoing connection (most likely for testing)
  """

  def start_link() do
    {:ok, mat} = PubSub.start_link()
  end

  def ping(mat) when is_pid(mat) do
    :ok
  end

  def pub(_mat, topic, message) do
    :ok = PubSub.publish(topic, {:msg, message})
  end

  def sub(_mat, pid, topic) do
    :ok = PubSub.subscribe(pid, topic)
  end
end
