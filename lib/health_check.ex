defmodule Bifrost.HealthCheck do
  use GenServer
  def start_link(%{gnat: gnat}=opts) do
    {:ok, pid} = GenServer.start_link(__MODULE__, opts)
  end

  def init(%{gnat: gnat}=opts) do
    :ok = Gnat.ping(gnat)
    schedule_check()
    {:ok, opts}
  end

  def handle_info(:check, %{gnat: gnat}=opts) do
    :ok = Gnat.ping(gnat)
    :ok = GenServer.cast(:check, opts)       # where is this cast going?
    {:noreply, opts}
  end

  def schedule_check() do
    Process.send_after(self(), :check, 500)
  end

end
