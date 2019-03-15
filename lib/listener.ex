defmodule Toskr.Listener do
  use GenStage, restart: :transient
  @moduledoc """
  This module wraps the genstage listeners which pass off event messages to the consumersupervisor.
  """
  @gnat_client Toskr.Config.nats_client()
  # =====================
  # Server methods
  # =====================

  @spec start_link(%{funk: any(), gnat: any(), module: any(), topic: any()}) :: {:ok, pid()}
  def start_link(%{topic: topic, module: module, funk: funk, gnat: gnat}) do
    {:ok, _listener} = GenStage.start_link(__MODULE__, %{topic: topic, module: module, funk: funk, gnat: gnat}, name: String.to_atom(topic))
  end

  @spec init(%{
          funk: any(),
          gnat: atom() | pid() | {atom(), any()} | {:via, atom(), any()},
          module: any(),
          topic: binary()
        }) :: {:producer, %{demand: 0, funk: any(), messages: [], module: any()}}
  def init(%{topic: topic, module: module, funk: funk, gnat: gnat}) do
    @gnat_client.sub(gnat, self(), topic)
    {:producer, %{module: module, funk: funk, demand: 0, messages: []}}
  end

  @spec handle_demand(number(), %{demand: number()}) ::
          {:noreply, [any()], %{demand: number(), messages: [any()]}}
  def handle_demand(demand, state) when demand > 0 do
    dispatch_messages(%{state | demand: state.demand + demand})
  end

  @spec handle_info({:msg, %{body: any(), topic: any()}}, %{messages: any()}) ::
          {:noreply, [any()], %{demand: number(), messages: [any()]}}
  def handle_info({:msg, %{body: body, topic: _topic}}, state) do
    event =
      body
      |>Jason.decode!()
      |>format()
      |>Map.put(:module, state[:module])
      |>Map.put(:funk, state[:funk])

    dispatch_messages(%{state| messages: [event | state[:messages]]})
  end

  # =====================
  # Helper methods
  # =====================

  @spec format(any()) :: any()
  def format(opts) when is_map(opts) do
    opts
    |>Map.new(fn {k, v} -> {String.to_atom(k), format(v)} end)
  end

  def format(opts) do
    opts
  end

  @spec dispatch_messages(%{demand: number(), messages: any()}) ::
          {:noreply, [any()], %{demand: number(), messages: [any()]}}
  def dispatch_messages(%{demand: demand, messages: messages} = state) do
    events = Enum.take(messages, -demand)
    remaining_messages = Enum.drop(messages, -demand)

    {:noreply, events, %{state |
      demand: demand - length(events),
      messages: remaining_messages } }
  end

end
