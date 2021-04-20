defmodule YouSpeak.Groups.UseCases.Get do
  @moduledoc """
  Gets a group by ID
  """

  import Ecto.Query, warn: false

  alias YouSpeak.Groups.Schemas.Group
  alias YouSpeak.Repo

  @type params() :: %{
          group_id: integer(),
          teacher_id: integer()
        }

  @type group_or_exception :: YouSpeak.Teachers.Schemas.Group | Ecto.NoResultsError

  @doc """
  Gets a given group by its ID and teacher

      iex> YouSpeak.Groups.UseCases.Get.call(%{group_id: 1, teacher_id: 22})
      iex> %YouSpeak.Groups.Schemas.Group{}

      Params:

      - params: %{group_id: 1, teacher_id: 2}
  """
  @spec call(params()) :: group_or_exception
  def call(%{group_id: group_id, teacher_id: teacher_id}) do
    from(
      group in Group,
      where: group.id == ^group_id and group.teacher_id == ^teacher_id
    )
    |> Repo.one!()
  end
end
