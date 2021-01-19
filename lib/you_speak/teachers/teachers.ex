defmodule YouSpeak.Teachers do
  @moduledoc """
  Teachers bounded context contains all the use cases available to the Teachers context.
  """

  alias YouSpeak.Teachers.UseCases.{FindByUserID, Registration}

  @spec registration(map()) :: Registration.ok_teacher_or_error_changeset()
  def registration(params), do: Registration.call(params)

  @spec find_by_user_id(integer()) :: YouSpeak.Teachers.Schemas.Teacher | nil
  def find_by_user_id(params), do: FindByUserID.call(params)
end
