defmodule YouSpeak.Auth do
  @moduledoc """
  Auth bounded context contains all the use cases available to the Auth context.
  """

  @spec find_or_create(map()) :: YouSpeak.Auth.UseCases.FindOrCreate.ok_user_or_error_string
  def find_or_create(params), do: YouSpeak.Auth.UseCases.FindOrCreate.call(params)
end
