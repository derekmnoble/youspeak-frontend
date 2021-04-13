defmodule YouSpeak.Meetings.UseCases.Meetings.GetTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Meetings.Schemas.Meeting
  alias YouSpeak.Meetings.UseCases.Meetings.Get

  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)
  def group_factory(attributes \\ %{}), do: Factory.insert!(:group, attributes)

  test "call/1 with an existent group" do
    params = %{
      name: "My meeting",
      description: "description",
      video_url: "https://www.youtube.com/watch?v=0tTgU7CYfgk",
      group_id: group_factory().id
    }

    {:ok, meeting} =
      %Meeting{}
      |> Meeting.changeset(params)
      |> Repo.insert()

    params = %{meeting_id: meeting.id, group_id: meeting.group_id}

    result = Get.call(params)

    assert result.id == meeting.id
  end

  test "call/1 with invalid group returns nil" do
    assert_raise Ecto.NoResultsError, fn ->
      Get.call(%{meeting_id: 999, group_id: group_factory().id})
    end
  end
end
