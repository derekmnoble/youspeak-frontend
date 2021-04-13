defmodule YouSpeak.Meetings do
  @moduledoc """
  Meetings bounded context contains all use cases available to the Meetings context.
  """

  alias YouSpeak.Meetings.UseCases.Meetings.{Create, ListByGroupSlug, GetBySlug, Get, Update}

  @spec create(Create.params()) :: Create.ok_meeting_or_error_changeset()
  def create(params), do: Create.call(params)

  @spec list_by_group_slug(ListByGroupSlug.params()) :: ListByGroupSlug.meetings_or_empty()
  def list_by_group_slug(params), do: ListByGroupSlug.call(params)

  @spec get_by_slug!(GetBySlug.params()) :: Get.meeting_or_exception()
  def get_by_slug!(params), do: GetBySlug.call(params)

  @spec get!(Get.params()) :: Get.meeting_or_exception()
  def get!(params), do: Get.call(params)

  @spec update(integer(), Update.params()) :: Update.ok_meeting_or_error_changeset()
  def update(meeting_id, params), do: Update.call(meeting_id, params)
end
