defmodule Bifrost do
  use Supervisor
  alias Bifrost.{
    Pipeline, 
    HealthCheck,
  }

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(_opts) do
    {:ok, gnat} = Gnat.start_link(Bifrost.Config.host_config())
    
    children = [
      worker(HealthCheck,[ %{gnat: gnat} ], shutdown: :brutal_kill),
      supervisor(Pipeline, [ %{gnat: gnat} ]),
    ]

    {:ok, _supervisor} = Supervisor.init(children, strategy: :rest_for_one)
  end

end