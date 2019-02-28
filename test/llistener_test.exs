defmodule ListenerTest do
  use ExUnit.Case
  alias Bifrost.{
    Listener
  }

  test "format returns an atom map when given a string map" do
    map = %{
      "foo" => 2,
      "bar" => "value",
      "baz" => [1,2,3],
    }
    expected = %{
      :foo => 2,
      :bar => "value",
      :baz => [1,2,3],
    }

    assert Listener.format(map) == expected 
  end

  test "format returns an atom map when given a string map recursively" do
    map = %{
      "foo" => 2,
      "bar" => %{"foo1"=>1, "bar1" => "example"},
      "baz" => [1,2,3],
    }
    expected = %{
      :foo => 2,
      :bar => %{:foo1=>1, :bar1 => "example"},
      :baz => [1,2,3],
    }

    assert Listener.format(map) == expected 
  end

  @tag :skip
  test "it should receive published messages" do

  end

  @tag :skip
  test "handle info should add event to state" do

  end

  @tag :skip
  test "dispatch messages should return the requested number of events and removes them from the queue" do

  end

  @tag :skip
  test "messages get added to the beginning of the queue" do

  end


end