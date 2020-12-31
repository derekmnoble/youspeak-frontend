defmodule YouSpeak.Groups.UseCases.ListByTeacherID do
  @moduledoc """
  Returns a list of groups based on the teacher.id
  """

  import Ecto.Query, warn: false

  alias YouSpeak.Groups.Schemas.Group

  @doc """
  Returns a list of groups based on the teacher.id

      iex> YouSpeak.Groups.UseCases.ListByTeacherID.call(1)
      iex> []

      Params:

      - teacher_id
  """

  @spec call(integer()) :: [YouSpeak.Groups.Schemas.Group] | []
  def call(teacher_id) do
    query = from(group in Group, where: group.teacher_id == ^teacher_id)

    YouSpeak.Repo.all(query)
  end
end
