defmodule YouSpeak.Meetings.UseCases.Comments.Create do
  @moduledoc """
  Create a new comment for a meeting
  """

  import Ecto.Query, warn: false

  alias YouSpeak.Meetings.Schemas.Comment
  alias YouSpeak.Repo

  @typedoc """
  Params used to create new record
  """
  @type params :: %{
          url: String.t(),
          user_id: integer(),
          meeting_id: integer()
        }

  @typedoc """
  Retuned typespec for given function
  """
  @type ok_comment_or_error_changeset ::
          {:ok, YouSpeak.Meetings.Schemas.Comment} | {:error, %Ecto.Changeset{}}

  @doc """
  Creates a new comment to a given group

      iex> YouSpeak.Meetings.UseCases.Meetings.Comment.call(%{url: "Test", meeting_id: 1, user_id: 1})
      iex> %YouSpeak.Meetings.Schemas.Comment{}

      Params:

      - params: Map with attributes (url, user_id, meeting_id are required)
  """
  @spec call(params()) :: ok_comment_or_error_changeset
  def call(params) do
    %Comment{}
    |> Comment.changeset(params)
    |> Repo.insert()
  end
end
