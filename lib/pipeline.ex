defmodule Toskr.Pipeline do
  require IEx
  use Supervisor
  alias Toskr.{
    Listener,
  }

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts)
  end

  def init( %{gnat: gnat} ) do
    :ok = Gnat.ping(gnat)

    listeners =
      TopicRouter.routes()
      |>Enum.map(fn(x) -> Tuple.append(x, gnat) end)
      |>Enum.map(&__MODULE__.spec_listener/1)

    children = listeners ++ [supervisor(Toskr.Handler, [listeners])]

    {:ok, _supervisor} = Supervisor.init(children, strategy: :one_for_one)
  end

  def spec_listener({topic, module, funk, gnat}) do
    worker(Listener, [%{topic: topic, module: module, funk: funk, gnat: gnat} ],
           id:  String.to_atom(topic),
           restart: :permanent)
  end
end
