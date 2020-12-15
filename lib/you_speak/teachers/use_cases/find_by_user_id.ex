defmodule YouSpeak.Teachers.UseCases.FindByUserID do
  @moduledoc """
  FindByUserID return a teacher based on the user_id or raises and error.
  """

  alias YouSpeak.Teachers.Schemas.Teacher

  def call(user_id) do
    YouSpeak.Repo.get_by!(Teacher, user_id: user_id)
  end
end
