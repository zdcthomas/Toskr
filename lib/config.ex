defmodule Toskr.Config do
  @moduledoc """
    This module provides  wrapper for all configurable state of the system.
  """

  def host_config() do
    %{
      host: nats_host(),
      port: nats_port(),
      connection_timeout: nats_timeout(),
    }
  end

  def nats_host do
    System.get_env("NATS_HOST") || "127.0.0.1"
  end

  def nats_port do
    int_or_default(System.get_env("NATS_PORT"), 4222 )
  end

  def nats_timeout do
    int_or_default(System.get_env("NATS_timeout"), 3000 )
  end

  def int_or_default(var, _default) when is_binary(var) do
    {num, _} = Integer.parse(var)
    num
  end

  def int_or_default(_var, default) do
    default
  end

  def nats_client() do
    case Application.get_env(:toskr, :nats_client) do
      :mock ->
        Toskr.Mat
      nil   ->
        Gnat
    end
  end

end
