defmodule YouSpeak.Groups do
  @moduledoc """
  Groups bounded context contains all use cases available to the Groups context.
  """

  alias YouSpeak.Groups.UseCases.{Create, Get, Update, Delete, ListByTeacherID}

  @spec create(Create.params()) :: Create.ok_group_or_error_changeset()
  def create(params), do: Create.call(params)

  @spec list_by_teacher_id(integer()) :: ListByTeacherID.groups_or_empty()
  def list_by_teacher_id(params), do: ListByTeacherID.call(params)

  @spec get(Get.params()) :: Get.group_or_nil()
  def get(params), do: Get.call(params)

  @spec update(integer(), Update.params()) :: Update.ok_group_or_error_changeset()
  def update(group_id, params), do: Update.call(group_id, params)

  @spec delete(Delete.params(), integer()) :: Delete.ok_group_or_error_changeset()
  def delete(group, teacher_id), do: Delete.call(group, teacher_id)
end