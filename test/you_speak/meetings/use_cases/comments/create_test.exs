defmodule YouSpeak.Meetings.UseCases.Comments.CreateTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Meetings.UseCases.Comments.Create

  def meeting_factory(attributes \\ %{}), do: Factory.build(:meeting, attributes)
  def user_factory(attributes \\ %{}), do: Factory.insert!(:user, attributes)

  defp add_meeting_id(comment_params, meeting_id),
    do: Map.put(comment_params, :meeting_id, meeting_id)

  defp add_user_id(comment_params, user_id), do: Map.put(comment_params, :user_id, user_id)

  setup do
    user = user_factory()

    {:ok, meeting} =
      meeting_factory()
      |> YouSpeak.Meetings.Schemas.Meeting.changeset(%{
        video_url: "http://www.youtube.com/watch?v=YGMQU1L9LKg"
      })
      |> YouSpeak.Repo.insert()

    {:ok, user: user, meeting: meeting}
  end

  test "call/1 with blank url must return changeset error", %{user: user, meeting: meeting} do
    params =
      %{url: ""}
      |> add_meeting_id(meeting.id)
      |> add_user_id(user.id)

    {:error, changeset} = Create.call(params)

    assert "can't be blank" in errors_on(changeset).url
  end

  test "call/1 with valid data must create a meeting", %{user: user, meeting: meeting} do
    params =
      %{url: "url"}
      |> add_meeting_id(meeting.id)
      |> add_user_id(user.id)

    {:ok, comment} = Create.call(params)

    assert comment.url == params.url
    assert comment.user_id == user.id
    assert comment.meeting_id == meeting.id
  end
end
