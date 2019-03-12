defmodule Toskr.EventBody do
  @moduledoc """
  This defines the structure of the event messages to be received.
  In future, I hope for this to be more configurable.
  """
  @derive Jason.Encoder

  defstruct [:id, :context, :meta, :at, :topic]
end
