defmodule Bifrost.Listener do
  use GenStage, restart: :transient

  def start_link(%{topic: topic, module: module, funk: funk, gnat: gnat}) do
    {:ok, listener} = GenStage.start_link(__MODULE__, %{topic: topic, module: module, funk: funk, gnat: gnat}, name: String.to_atom(topic)) # maybe _listener
  end

  def init(%{topic: topic, module: module, funk: funk, gnat: gnat}) do
    Gnat.sub(gnat, self(), topic)
    {:producer, %{module: module, funk: funk, demand: 0, messages: []}}
  end

  def handle_demand(demand, state) when demand > 0 do
    dispatch_messages(%{state | demand: state.demand + demand})
  end

  def handle_info({:msg, %{body: body, topic: topic}} = params, state) do  # maybe _params, _topic
    event = Jason.decode!(body)
      |> format()
      |>Map.put(:module, state[:module])
      |>Map.put(:funk, state[:funk])

    dispatch_messages(%{state| messages: [event | state[:messages]]})
  end

  def format(opts) when is_map(opts) do
    opts
    |>Map.new(fn {k, v} -> {String.to_atom(k), format(v)} end)  # this is a potential DOS vector, as atoms aren't
                                                                # garbage collected

  def format(opts) do
    opts
  end

  def dispatch_messages(%{demand: demand, messages: messages} = state) do
    events = Enum.take(messages, -demand)
    remaining_messages = Enum.drop(messages, -demand)

    {:noreply, events, %{state |
      demand: demand - length(events),
      messages: remaining_messages } }
  end

end
