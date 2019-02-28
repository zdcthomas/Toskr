ExUnit.start()
require IEx
case :gen_tcp.connect('localhost', 4222, [:binary]) do
  {:ok, socket} ->
    :gen_tcp.close(socket)
  {:error, reason} ->
    Mix.raise "Cannot connect to gnatsd" <>
              " (http://localhost:4222):" <>
              " #{:inet.format_error(reason)}\n" <>
              "You probably need to start gnatsd.\n" <>
              "gnatsd can be installed with brew"
end

defmodule TestModule do

  def foo(params) do
    pid = 
      params[:context][:object]
      |>pid_from_string()
    subject = params[:context][:subject]
    send(pid, {:received, subject}) 
  end

  def bar(body) do
    IO.inspect body: body
  end

  def pid_from_string("#PID" <> string) do
    string
    |> :erlang.binary_to_list
    |> :erlang.list_to_pid
  end
  def pid_from_string(string) do
    string
    |> :erlang.binary_to_list
    |> :erlang.list_to_pid
  end
end

defmodule TopicRouter do

  def foo_topic do
   "foo" 
  end

  def bar_topic do
    "bar"
  end

  def routes() do
    [
      {foo_topic(), TestModule, :foo },
      {bar_topic(), TestModule, :bar }
    ]
  end
end