defmodule YouSpeak.Groups.UseCases.ListByTeacherIDTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Groups.UseCases.ListByTeacherID

  doctest YouSpeak.Groups.UseCases.ListByTeacherID

  def group_factory(attributes \\ %{}), do: Factory.insert!(:group, attributes)
  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)

  test "call/1 with invalid teacher_id must return an empty list" do
    assert [] == ListByTeacherID.call(999_999)
  end

  test "call/1 with valid teacher_id must return a list of groups" do
    teacher_one = teacher_factory()
    group_one = group_factory(%{teacher_id: teacher_one.id})
    group_two = group_factory(%{teacher_id: teacher_one.id})

    teacher_two = teacher_factory()
    group_three = group_factory(%{teacher_id: teacher_two.id})

    result = ListByTeacherID.call(teacher_one.id)

    group_ids = Enum.map(result, fn result -> result.id end)
    # group_ids = Enum.map(result, &(&1.id))

    assert group_one.id in group_ids
    assert group_two.id in group_ids
    refute group_three in group_ids
  end
end
