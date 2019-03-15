defmodule Toskr.Handler do
  @moduledoc """
  This module is the consumer supervisor which receives subscriptions from the listeners.
  The current name is somewhat misleading as it does not actually "handle" any of the messages
  """
  alias Toskr.{
    Worker,
    Listener,
    Eventbody,
    State,
  }

  use ConsumerSupervisor

  def start_link(opts) do
    ConsumerSupervisor.start_link(__MODULE__, opts)
  end

  def init(listeners) do
    subs =
      listeners
      |>Enum.map(fn(worker) -> elem(worker, 0) end)
      |>Enum.map(fn(worker) -> {worker, max_demand: 2}end)

    children = [%{id: Worker, restart: :transient, start: {Worker, :start_link, []}}]
    opts = [strategy: :one_for_one, subscribe_to: subs]
    {:ok, _, _con_supervisor} = ConsumerSupervisor.init(children, opts)
  end

end
