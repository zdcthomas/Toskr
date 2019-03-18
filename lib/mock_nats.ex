defmodule Toskr.Mat do
  @moduledoc """
  This module mocks out the `Gnat` module's behaviour, to avoid any outgoing connection (most likely for testing)
  """

  def start_link() do
    case PubSub.start_link() do
      {:ok, mat} -> {:ok, mat}
      {:error, {:already_started, mat}} -> {:ok, mat }
    end
  end

  def start_link(_opts) do
    {:ok, _mat} = PubSub.start_link()
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

  def test_sub(pid, topic) when is_pid(pid) do
    :ok = PubSub.subscribe(pid, topic)
  end
end
