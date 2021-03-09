defmodule YouSpeak.Meetings do
  @moduledoc """
  Meetings bounded context contains all use cases available to the Meetings context.
  """

  alias YouSpeak.Meetings.UseCases.{Create, ListByGroupSlug}

  @spec create(Create.params()) :: Create.ok_meeting_or_error_changeset()
  def create(params), do: Create.call(params)

  @spec list_by_group_slug(ListByGroupSlug.params()) :: ListByGroupSlug.meetings_or_empty()
  def list_by_group_slug(params), do: ListByGroupSlug.call(params)
end
