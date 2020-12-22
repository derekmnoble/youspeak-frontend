defmodule YouSpeak.Auth do
  @moduledoc """
  Auth bounded context contains all the use cases available to the Auth context.
  """

  @spec find_or_create(map()) :: {:ok, %YouSpeak.Auth.Schemas.User{}} | {:error, String.t()}
  def find_or_create(params), do: YouSpeak.Auth.UseCases.FindOrCreate.call(params)
end
