defmodule YouSpeak.Auth do
  @moduledoc """
  Auth bounded context, it contains all the use cases available to the Auth context.
  """

  def find_or_create(params), do: YouSpeak.Auth.UseCases.FindOrCreate.call(params)
end
