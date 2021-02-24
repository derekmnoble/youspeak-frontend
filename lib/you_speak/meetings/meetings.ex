defmodule YouSpeak.Meetings do
  @moduledoc """
  Meetings bounded context contains all use cases available to the Meetings context.
  """

  alias YouSpeak.Meetings.UseCases.{Create}

  @spec create(Create.params()) :: Create.ok_meeting_or_error_changeset()
  def create(params), do: Create.call(params)
end
