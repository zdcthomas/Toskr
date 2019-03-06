defmodule ListenerTest do
  use ExUnit.Case
  require IEx
  alias Bifrost.{
    Listener
  }

  def nats_params(params \\ %{}) when is_map(params) do
    topic = Map.get(params, :topic) || "foo"
    message_body = %{
      id:      Map.get(params, :id)      || 1,
      context: Map.get(params, :context) || %{object: Map.get(params, :object)   || inspect(self()),
                                             subject: Map.get(params, :subject) || "foo"},
      meta:    Map.get(params, :meta)    || %{sent: 'yesterday'}, 
      at:      Map.get(params, :at)      || ~T[23:00:07.001],
      topic:   Map.get(params, :topic)   ||  TopicRouter.foo_topic,
    }

    body = Jason.encode!(message_body)
    {:msg, %{body: body, topic: topic}}
  end

  describe "#format/1" do
    test "format returns an atom map when given a string map" do
      map = %{
        "foo" => 2,
        "bar" => "value",
        "baz" => [1, 2, 3],
      }
      expected = %{
        :foo => 2,
        :bar => "value",
        :baz => [1, 2, 3],
      }

      assert Listener.format(map) == expected 
    end

    test "format returns an atom map when given a string map recursively" do
      map = %{
        "foo" => 2,
        "bar" => %{"foo1"=>1, "bar1" => "example"},
        "baz" => [1, 2, 3],
      }
      expected = %{
        :foo => 2,
        :bar => %{:foo1=>1, :bar1 => "example"},
        :baz => [1, 2, 3], 
      }

      assert Listener.format(map) == expected 
    end
  end

  test "handle info should add event to state" do
    state  = %{module: TestModule, funk: :foo, demand: 0, messages: []}
    params = nats_params()

    {:noreply, events, state} = Listener.handle_info(params, state)
    state_messages = Map.get(state, :messages)
    assert Enum.count(state_messages) == 1
  end

  test "dispatch messages should return the requested number of events and removes them from the queue" do
    state  = %{module: TestModule, funk: :foo, demand: 0, messages: []}
    params = nats_params()

    {:noreply, events, state} = Listener.handle_info(params, state)
    assert events == []
    assert Map.get(state, :demand) == 0 

    state  = %{module: TestModule, funk: :foo, demand: 1, messages: []}
    params = nats_params()

    {:noreply, events, state} = Listener.handle_info(params, state)
    assert Enum.count(events) == 1
    assert Map.get(state, :demand) == 0 
  end

  test "messages get added to the beginning of the queue" do
    state  = %{module: TestModule, funk: :foo, demand: 0, messages: []}
    params = nats_params()
    {:noreply, events, state} = Listener.handle_info(params, state)
    params = nats_params(%{id: 2})
    {:noreply, events, state} = Listener.handle_info(params, state)

    messages = Map.get(state, :messages)
    assert Enum.count(messages) == 2
    [first, next] = messages
    assert Map.get(next, :id) == 1
    assert Map.get(first, :id) == 2
  end

end