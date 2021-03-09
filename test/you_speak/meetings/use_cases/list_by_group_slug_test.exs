defmodule YouSpeak.Meetings.UseCases.ListByGroupSlugTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Meetings.UseCases.ListByGroupSlug

  doctest YouSpeak.Meetings.UseCases.ListByGroupSlug

  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)
  def group_factory(attributes \\ %{}), do: Factory.build(:group, attributes)
  def meeting_factory(attributes \\ %{}), do: Factory.insert!(:meeting, attributes)

  test "call/1 with invalid group_slug must return an empty list" do
    assert [] == ListByGroupSlug.call(%{slug: "invalid_slug", teacher_id: 999})
  end

  test "call/1 with valid group.slug must return a list of meetings" do
    teacher_one = teacher_factory()

    {:ok, group_one} =
      group_factory()
      |> YouSpeak.Groups.Schemas.Group.changeset(%{name: "My name", teacher_id: teacher_one.id})
      |> YouSpeak.Repo.insert()

    meeting_one = meeting_factory(%{group_id: group_one.id})
    meeting_two = meeting_factory(%{group_id: group_one.id})

    group_two = group_factory(%{teacher_id: teacher_one.id})
    meeting_three = meeting_factory(%{group_id: group_two.id})

    result = ListByGroupSlug.call(%{slug: group_one.slug, teacher_id: teacher_one.id})

    meeting_ids = Enum.map(result, & &1.id)

    assert meeting_one.id in meeting_ids
    assert meeting_two.id in meeting_ids
    refute meeting_three.id in meeting_ids
  end
end
