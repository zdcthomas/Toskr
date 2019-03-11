defmodule WorkerTest do
  use ExUnit.Case
  alias Toskr.{
    Worker,
  }
  doctest Worker

  test "The worker will apply the method given in start_link" do
    subject = "received message"
    params = %{
      module: TestModule,
      funk: :foo,
      id: 1,
      context: %{object: inspect(self()), subject: subject},
      meta: %{sent: 'yesterday'},
      at: ~T[23:00:07.001],
      topic: TopicRouter.foo_topic,
    }

    Worker.start_link(params)

    receive do
      {:received, received} -> assert subject == received
    after
      1000 -> flunk("No callback was received")
    end

  end

end
