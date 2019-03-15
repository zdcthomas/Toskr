defmodule ToskrTest do
  use ExUnit.Case
  require IEx

  test "it starts up something" do
    {:ok, pid} = Toskr.start_link([])
    assert is_pid(pid)
  end

  test "it starts up a worker and a supervisor" do
    {:ok, supervisor} = start_supervised({Toskr, []})

    supervisor_children =
      supervisor
      |>Supervisor.count_children()

    workers = Map.get(supervisor_children, :workers)
    supervisors = Map.get(supervisor_children, :supervisors)

    assert workers == 1
    assert supervisors == 1
  end

  describe "publish" do
    test "publishing with just the context should publish an eventbody struct" do
      context = %{object:
                    %{foo: "bar"},
                  subject:
                    %{baz: "bop"}
                  }
      topic = "pub.test"
      {:ok, pid} = Gnat.start_link()
      {:ok, _subscription} = Gnat.sub(pid, self(), topic)
      Toskr.publish(pid, topic, context: context)

      receive do
        {:msg, %{body: body}} ->
          parsed =
            body
            |>Jason.decode!()
            |>Toskr.Listener.format()

          assert parsed[:topic] == topic
          assert parsed[:context] == context
      after
        1000 -> flunk("No callback was received")
      end

    end
  end

end
