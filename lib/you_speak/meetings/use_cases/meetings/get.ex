defmodule YouSpeak.Meetings.UseCases.Meetings.Get do
  @moduledoc """
  Gets a meeting by slug
  """

  import Ecto.Query, warn: false

  alias YouSpeak.Meetings.Schemas.Meeting
  alias YouSpeak.Repo

  @type params() :: %{
          meeting_id: integer(),
          group_id: integer()
        }

  @type meeting_or_exception :: Meeting | Ecto.NoResultsError

  @doc """
  Gets a given meeting by its slug and group_id

      iex> YouSpeak.Meetings.UseCases.Meetings.Get.call(%{meeting_id: 1, group_id: 22})
      iex> %YouSpeak.Meetings.Schemas.Meeting{}

      Params:

      - params: %{slug: "group-slug", group_id: 2}
  """
  @spec call(params()) :: meeting_or_exception
  def call(%{meeting_id: meeting_id, group_id: group_id}) do
    from(
      meeting in Meeting,
      where: meeting.id == ^meeting_id and meeting.group_id == ^group_id
    )
    |> Repo.one!()
  end
end
