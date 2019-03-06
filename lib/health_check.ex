defmodule Bifrost.HealthCheck do
  use GenServer
  @gnat_client Bifrost.Config.nats_client()

  def start_link(%{gnat: gnat} = opts) do
    {:ok, pid} = GenServer.start_link(__MODULE__, opts)
  end

  def init(%{gnat: gnat} = opts) do
    :ok = @gnat_client.ping(gnat)
    schedule_check()
    {:ok, opts}
  end

  def handle_info(:check, %{gnat: gnat} = opts) do
    :ok = @gnat_client.ping(gnat)
    :ok = GenServer.cast(:check, opts)
    {:noreply, opts}
  end

  def schedule_check() do
    Process.send_after(self(), :check, 500)
  end

end