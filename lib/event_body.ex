defmodule Bifrost.EventBody do
  @derive Jason.Encoder

  defstruct [:id, :context, :meta, :at, :topic]
end