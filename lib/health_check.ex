defmodule Toskr.HealthCheck do
  use GenServer
  @gnat_client Toskr.Config.nats_client()
  @check_freq 500
  @moduledoc """
  This module will check the health of nats periodically.
  This amount is currently set in module in the check_freq var,
  however, there are plans to extract this to be an env var.
  """

  def start_link(%{gnat: _gnat} = opts) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, opts)
  end

  def init(%{gnat: gnat} = opts) do
    :ok = @gnat_client.ping(gnat)
    schedule_check()
    {:ok, opts}
  end

  def handle_info(:check, %{gnat: gnat} = opts) do
    :ok = @gnat_client.ping(gnat)
    schedule_check()
    {:noreply, opts}
  end

  def schedule_check() do
    Process.send_after(self(), :check, @check_freq)
  end

end
