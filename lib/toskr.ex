defmodule Toskr do
  @moduledoc """
  This module is the entry point for the entire app.
  Init will start up:
    * The health check worker which will ping nats on a loop
    * The Pipeline supervisor, which will start up the listeners and consumer supervisor underneath it

  """
  use Supervisor
  alias Toskr.{
    Pipeline,
    HealthCheck,
    Config,
  }
  @gnat_client Config.nats_client()

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(_opts) do
    {:ok, gnat} = start_nats()

    children = [
      worker(HealthCheck, [%{gnat: gnat}], shutdown: :brutal_kill),
      supervisor(Pipeline, [%{gnat: gnat}]),
    ]

    {:ok, _supervisor} = Supervisor.init(children, strategy: :rest_for_one)
  end

  @spec start_nats() :: {:ok, pid()}
  def start_nats() do
    {:ok, _gnat} = @gnat_client.start_link(Toskr.Config.host_config())
  end

  @spec publish(pid(), binary(), map()) :: :ok
  def publish(gnat, topic, message) when is_pid(gnat) and is_map(message) do
    json_message = Jason.encode!(message)
    :ok = @gnat_client.pub(gnat, topic, json_message)
  end

  def publish(topic, message) do
    {:ok, gnat} = start_nats()
    :ok = @gnat_client.pub(gnat, topic, message)
  end

end
