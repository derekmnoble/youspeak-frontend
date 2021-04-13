defmodule YouSpeak.Meetings.UseCases.Meetings.ListByGroupSlug do
  @moduledoc """
  Returns a list of meetings based on the group.slug
  """

  import Ecto.Query, warn: false

  alias YouSpeak.Meetings.Schemas.Meeting
  alias YouSpeak.Repo

  @type meetings_or_empty :: [Meeting] | []

  @typedoc """
  Params used list meetings
  """
  @type params() :: %{
          slug: String.t(),
          teacher_id: integer()
        }

  @doc """
  Returns a list of meetings based on the group.slug

      iex> YouSpeak.Meetings.UseCases.Meetings.ListByGroupSlug.call(%{slug: "group-slug", teacher_id: 1})
      iex> [%YouSpeak.Meetings.Schemas.Meeting{}]

      Params:

      - group_slug
  """
  @spec call(params) :: meetings_or_empty
  def call(params) do
    group = YouSpeak.Groups.get_by_slug!(params)

    from(
      meeting in Meeting,
      where: meeting.group_id == ^group.id
    )
    |> Repo.all()
  rescue
    Ecto.NoResultsError ->
      []
  end
end
