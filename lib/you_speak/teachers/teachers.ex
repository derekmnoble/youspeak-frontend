defmodule YouSpeak.Teachers do
  @moduledoc """
  Teachers bounded context contains all the use cases available to the Teachers context.
  """

  @spec registration(map()) :: {:ok, YouSpeak.Teachers.Schemas.Teacher} | {:error, %Ecto.Changeset{}}
  def registration(params), do: YouSpeak.Teachers.UseCases.Registration.call(params)

  @spec find_by_user_id(integer()) :: YouSpeak.Teachers.Schemas.Teacher | nil
  def find_by_user_id(params), do: YouSpeak.Teachers.UseCases.FindByUserID.call(params)
end
