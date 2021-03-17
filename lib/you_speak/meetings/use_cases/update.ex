defmodule YouSpeak.Meetings.UseCases.Update do
  @moduledoc """
  Updates a given meeting
  """

  import Ecto.Query, warn: false

  alias YouSpeak.Meetings.Schemas.Meeting
  alias YouSpeak.Repo

  @typedoc """
  Params use to update a meeting
  """

  @type params :: %{
          name: String.t(),
          description: String.t() | nil,
          video_url: nil,
          group_id: integer()
        }

  @typedoc """
  Retuned typespec for given function
  """
  @type ok_meeting_or_error_changeset ::
          {:ok, YouSpeak.Meetings.Schemas.Meeting} | {:error, %Ecto.Changeset{}}

  @doc """
  Updates a meeting

      iex> YouSpeak.Meetings.UseCases.Update.call(1, %{name: "Test"})
      iex> %YouSpeak.Meetings.Schemas.Group{}

      Params:

      - meeting_id: id to be updated
      - params: Map with attributes (name, video_url are required)
  """
  @spec call(integer(), params()) :: ok_meeting_or_error_changeset
  def call(meeting_id, %{group_id: group_id} = params) do
    from(
      meeting in Meeting,
      where: meeting.id == ^meeting_id and meeting.group_id == ^group_id
    )
    |> Repo.one()
    |> case do
      nil ->
        {:error, "invalid id"}

      meeting ->
        meeting
        |> Meeting.changeset(params)
        |> Repo.update()
    end
  end
end
