defmodule Toskr.EventBody do
  @moduledoc """
  This defines the structure of the event messages to be received.
  In future, I hope for this to be more configurable.
  """
  @derive Jason.Encoder
  alias Toskr.{
    EventBody
  }

  defstruct [:id, :context, :meta, :at, :topic]

  def generate_id() do
    UUID.uuid4()
  end

  def generate_timestamp() do
    DateTime.utc_now()
    |> DateTime.to_iso8601()
  end

  def default_meta() do
    %{
      platform: "Web",
    }
  end

  def event_body(%{} = context, topic, meta \\ %{}) when is_map(meta) do
    %EventBody{
      id: generate_id(),
      meta: Enum.into(meta, default_meta()),
      context: context,
      topic: topic,
      at: generate_timestamp(),
    }
  end
end
