defmodule YouSpeak.Meetings.UseCases.GetBySlugTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Meetings.Schemas.Meeting
  alias YouSpeak.Meetings.UseCases.GetBySlug

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

    params = %{slug: meeting.slug, group_id: meeting.group_id}

    result = GetBySlug.call(params)

    assert result.id == meeting.id
  end

  test "call/1 with invalid group returns nil" do
    assert_raise Ecto.NoResultsError, fn ->
      GetBySlug.call(%{slug: "invalid slug", group_id: group_factory().id})
    end
  end
end
