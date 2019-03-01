defmodule PipelineTest do
  use ExUnit.Case
  require IEx
  alias Bifrost.{ 
    EventBody,
    Pipeline,
  }
  doctest Pipeline
 
  test "it starts up something" do
    {:ok, gnat} = Gnat.start_link()
    {:ok, pid} = Pipeline.start_link(%{gnat: gnat})
    assert is_pid(pid)
  end

  test "it starts with the right number of children" do
    {:ok, gnat} = Gnat.start_link()
    {:ok, supervisor} = start_supervised({Pipeline, %{gnat: gnat}})

    supervisor_children =
      supervisor
      |>Supervisor.count_children()

    workers = Map.get(supervisor_children, :workers)
    supervisors = Map.get(supervisor_children, :supervisors)

    # this is the two listeners described in the fake router and the consumer supervisor 
    # listening to those
    assert workers == 2
    assert supervisors == 1
  end

  test "check that listeners on a topic will receive a callback" do
    {:ok, gnat} = Gnat.start_link()
    {:ok, _supervisor} = start_supervised({Pipeline, %{gnat: gnat}})

    subject = "subject to be returned"
    message_body = %EventBody{
      id: 1,
      context: %{object: inspect(self()), subject: subject},
      meta: %{sent: 'yesterday'}, 
      at: ~T[23:00:07.001],
      topic: TopicRouter.foo_topic
    }

    Gnat.pub(gnat, TopicRouter.foo_topic, Jason.encode!(message_body))

    receive do
      {:received, received} -> assert subject == received
    after
      100 -> flunk("No callback was received") 
    end

  end

end
