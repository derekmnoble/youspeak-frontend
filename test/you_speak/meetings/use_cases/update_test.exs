defmodule YouSpeak.Meetings.UseCases.UpdateTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Meetings.UseCases.Update

  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)
  def group_factory(attributes \\ %{}), do: Factory.insert!(:group, attributes)
  def meeting_factory(attributes \\ %{}), do: Factory.insert!(:meeting, attributes)

  test "call/2 with valid data must update the content" do
    group_id = group_factory().id

    meeting =
      meeting_factory(%{
        name: "Test",
        video_url: "https://www.youtube.com/watch?v=uxAziC38npI",
        group_id: group_id
      })

    new_params = %{
      name: "updated name",
      description: "updated desc",
      video_url: "http://www.youtube.com/watch?v=yVxisBhnmjI",
      group_id: group_id
    }

    {:ok, updated_meeting} = Update.call(meeting.id, new_params)

    assert updated_meeting.id == meeting.id
    assert updated_meeting.name == new_params.name
    assert updated_meeting.description == new_params.description
    assert updated_meeting.video_url == new_params.video_url
  end

  test "call/2 with invalid return changeset" do
    group_id = group_factory().id

    meeting =
      meeting_factory(%{
        name: "Test",
        video_url: "https://www.youtube.com/watch?v=uxAziC38npI",
        group_id: group_id
      })

    new_params = %{
      name: "",
      description: "updated desc",
      video_url: "",
      group_id: group_id
    }

    {:error, changeset} = Update.call(meeting.id, new_params)

    assert "can't be blank" in errors_on(changeset).name
    assert "can't be blank" in errors_on(changeset).video_url
  end

  test "call/2 with invalid record error" do
    assert {:error, "invalid id"} =
             Update.call(999, %{name: "updated test", group_id: group_factory().id})
  end
end
