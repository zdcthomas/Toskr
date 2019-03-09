defmodule Bifrost.Config do

  def host_config() do
    %{
      host: nats_host(),
      port: nats_port(),
      connection_timeout: nats_timeout(),
    }
  end

  def nats_host do
    System.get_env("NATS_HOST") || '127.0.0.1'
  end

  def nats_port do
    System.get_env("NATS_PORT") || 4222
  end

  def nats_timeout do
    System.get_env("NATS_timeout") || 3000   # Supposed to be lower case?
  end

end
