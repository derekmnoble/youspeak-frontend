defmodule YouSpeak.Meetings.UseCases.Meetings.CreateTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Meetings.UseCases.Meetings.Create

  def group_factory(attributes \\ %{}), do: Factory.build(:group, attributes)
  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)

  defp add_group_id(meeting_params, group_id), do: Map.put(meeting_params, :group_id, group_id)

  setup do
    teacher = teacher_factory()

    {:ok, group} =
      group_factory()
      |> YouSpeak.Groups.Schemas.Group.changeset(%{name: "My name", teacher_id: teacher.id})
      |> YouSpeak.Repo.insert()

    {:ok, group: group}
  end

  test "call/1 with blank name must return changeset error", %{group: group} do
    params =
      %{name: "", description: "", video_url: "video_url"}
      |> add_group_id(group.id)

    {:error, changeset} = Create.call(params)

    assert "can't be blank" in errors_on(changeset).name
  end

  test "call/1 with blank video_url must return changeset error", %{group: group} do
    params =
      %{name: "Name", description: "", video_url: ""}
      |> add_group_id(group.id)

    {:error, changeset} = Create.call(params)

    assert "can't be blank" in errors_on(changeset).video_url
  end

  test "call/1 with valid data must create a meeting", %{group: group} do
    params =
      %{name: "Name", description: "", video_url: "https://www.youtube.com/watch?v=2d_6EQx3Z84"}
      |> add_group_id(group.id)

    {:ok, meeting} = Create.call(params)

    assert meeting.name == params.name
    assert is_nil(meeting.description)
    assert meeting.group_id == group.id
  end
end
