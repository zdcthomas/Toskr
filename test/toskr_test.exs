defmodule BifrostTest do
  use ExUnit.Case
  require IEx

  test "it starts up something" do
    {:ok, pid} = Bifrost.start_link([])
    assert is_pid(pid)
  end

  test "it starts up a worker and a supervisor" do
    {:ok, supervisor} = start_supervised({Bifrost, []})

    supervisor_children =
      supervisor
      |>Supervisor.count_children()

    workers = Map.get(supervisor_children, :workers)
    supervisors = Map.get(supervisor_children, :supervisors)

    assert workers == 1
    assert supervisors == 1
  end

  test "it restarts both children when one dies" do

  end

  test "" do
    
  end

end