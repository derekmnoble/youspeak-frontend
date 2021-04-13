defmodule YouSpeak.Meetings.UseCases.Meetings.Create do
  @moduledoc """
  Creates a new group to teacher
  """

  import Ecto.Query, warn: false

  alias YouSpeak.Meetings.Schemas.Meeting
  alias YouSpeak.Repo

  @typedoc """
  Params used to create new record
  """
  @type params :: %{
          name: String.t(),
          description: String.t() | nil,
          video_url: String.t(),
          group_id: integer()
        }

  @typedoc """
  Retuned typespec for given function
  """
  @type ok_meeting_or_error_changeset ::
          {:ok, YouSpeak.Teachers.Schemas.Meeting} | {:error, %Ecto.Changeset{}}

  @doc """
  Creates a new meeting to a given group

      iex> YouSpeak.Meetings.UseCases.Meetings.Meeting.call(%{name: "Test", group_id: 1})
      iex> %YouSpeak.Meetings.Schemas.Meeting{}

      Params:

      - params: Map with attributes (name, description, video_url are required)
  """
  @spec call(params()) :: ok_meeting_or_error_changeset
  def call(params) do
    %Meeting{}
    |> Meeting.changeset(params)
    |> Repo.insert()
  end
end
