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
    {:ok, gnat} = start_nats()
    
    children = [
      worker(HealthCheck,[ %{gnat: gnat} ], shutdown: :brutal_kill),
      supervisor(Pipeline, [ %{gnat: gnat} ]),
    ]

    {:ok, _supervisor} = Supervisor.init(children, strategy: :rest_for_one)
  end

  def start_nats() do
    {:ok, gnat} = Gnat.start_link(Bifrost.Config.host_config())
  end

  def publish(gnat, topic, message) when is_pid(gnat) do
    {:ok, gnat} = start_nats()
    Gnat.pub(gnat, topic, message)
  end

  def publish(top, message) do
    Gnat.start_link()
  end

end