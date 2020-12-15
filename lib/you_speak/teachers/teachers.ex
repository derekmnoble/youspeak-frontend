defmodule YouSpeak.Teachers do
  @moduledoc """
  Teachers bounded context, it contains all the use cases available to the Teachers context.
  """

  def registration(params), do: YouSpeak.Teachers.UseCases.Registration.call(params)

  def find_by_user_id(params), do: YouSpeak.Teachers.UseCases.FindByUserID.call(params)
end
