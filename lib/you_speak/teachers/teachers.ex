defmodule YouSpeak.Teachers do
  @moduledoc """
  Teachers bounded context
  """

  def registration(params), do: YouSpeak.Teachers.UseCases.Registration.call(params)
end
