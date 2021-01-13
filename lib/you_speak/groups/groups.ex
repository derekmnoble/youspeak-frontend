defmodule YouSpeak.Groups do
  @moduledoc """
  Groups bounded context contains all use cases available to the Groups context.
  """

  alias YouSpeak.Groups.UseCases.{Create, Get, ListByTeacherID}

  @spec create(Create.map()) :: Create.ok_group_or_error_changeset
  def create(params), do: Create.call(params)

  @spec list_by_teacher_id(integer()) :: ListByTeacherID.groups_or_empty
  def list_by_teacher_id(params), do: ListByTeacherID.call(params)

  @spec get(integer()) :: Get.group_or_nil
  def get(params), do: Get.call(params)
end
