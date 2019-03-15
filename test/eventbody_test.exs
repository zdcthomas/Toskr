defmodule EventBodyTest do
  use ExUnit.Case
  alias Toskr.{
    EventBody,
  }
  require IEx

  test "generate id" do
    assert is_binary(EventBody.generate_id())
  end

  test "default meta" do
    assert %{platform: "Web"} == EventBody.default_meta()
  end

  describe "event_body/2" do
    test "it should populate context with the passed in map" do
      context = %{object:
                    %{foo: "bar"},
                  subject:
                    %{baz: "bop"}
                  }
      topic = "foo"
      event = EventBody.event_body(context, topic)

      assert %EventBody{} = event
      assert is_binary(event.id)
      assert {:ok, time, _} = DateTime.from_iso8601(event.at)
      assert event.context == context
      assert is_map(event.meta)
      assert event.meta[:platform] == "Web"
      assert event.topic == topic
    end

    test "the struct can be json encoded" do
      context = %{object:
                    %{foo: "bar"},
                  subject:
                    %{baz: "bop"}
                  }
      topic = "foo"
      event = EventBody.event_body(context, topic)

      event
      |>Jason.encode!()
      |>Jason.decode!()
      |>is_map()
    end

    test "it can take in additional meta info" do
      context = %{object:
                    %{foo: "bar"},
                  subject:
                    %{baz: "bop"}
                  }
      topic = "foo"
      meta = %{event_system: "NATS"}
      expected_meta = Map.put(meta, :platform, "Web")
      event = EventBody.event_body(context, topic, meta)
      assert event.meta == expected_meta
    end
  end


end
