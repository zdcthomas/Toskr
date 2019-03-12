defmodule Toskr.Worker do
  @moduledoc """
  This module is called by the consumersupervisor whenever a message is received.
  It receives the message, and begins a Task which executes the callback.
  This callback receieves the pure message body(A map) as it's only argument.
  """

  @spec start_link(%{funk: any(), module: any()}) :: {:ok, pid()}
  def start_link(%{module: module, funk: funk} = params) do
    body = Map.drop(params, [:module, :funk])
    Task.start_link(fn ->
      apply(module, funk, [body])
    end)
  end

end
