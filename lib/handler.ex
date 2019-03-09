defmodule Bifrost.Handler do
  alias Bifrost.{
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
      |>Enum.map(fn(worker)->elem(worker, 0)end)
      |>Enum.map(fn(worker)->{worker, max_demand: 2}end)

    children = [%{id: Worker, restart: :transient, start: {Worker, :start_link, []}}]
    opts = [strategy: :one_for_one, subscribe_to: subs]
    {:ok, a, con_supervisor} = ConsumerSupervisor.init(children, opts)  #Q matbe _a, _con_supervisor?
  end

end
