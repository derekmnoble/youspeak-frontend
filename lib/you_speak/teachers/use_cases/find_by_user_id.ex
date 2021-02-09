defmodule YouSpeak.Teachers.UseCases.FindByUserID do
  @moduledoc """
  Returns a teacher based current_user.id or returns new
  """

  alias YouSpeak.Teachers.Schemas.Teacher

  @doc """
  Returns a teacher based current_user.id or returns new

  ## Examples

      iex> YouSpeak.Teachers.UseCases.FindByUserID.call(1)
      iex> nil
  """
  @spec call(integer()) :: YouSpeak.Teachers.Schemas.Teacher | nil
  def call(user_id) do
    YouSpeak.Repo.get_by(Teacher, user_id: user_id)
  end
end
