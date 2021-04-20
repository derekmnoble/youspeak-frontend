defmodule YouSpeak.Meetings.UseCases.Meetings.GetBySlug do
  @moduledoc """
  Gets a meeting by slug
  """

  import Ecto.Query, warn: false

  alias YouSpeak.Meetings.Schemas.Meeting
  alias YouSpeak.Repo

  @type params() :: %{
          slug: String.t(),
          group_id: integer()
        }

  @type meeting_or_exception :: Meeting | Ecto.NoResultsError

  @doc """
  Gets a given meeting by its slug and group_id

      iex> YouSpeak.Meetings.UseCases.Meetings.GetBySlug.call(%{slug: "meeting-slug", group_id: 22})
      iex> %YouSpeak.Meetings.Schemas.Meeting{}

      Params:

      - params: %{slug: "group-slug", group_id: 2}
  """
  @spec call(params()) :: meeting_or_exception
  def call(%{slug: slug, group_id: group_id}) do
    from(
      meeting in Meeting,
      where: meeting.slug == ^slug and meeting.group_id == ^group_id
    )
    |> Repo.one!(preload: [:group])
  end
end
