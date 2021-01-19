defmodule YouSpeak.Groups.UseCases.CreateTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Groups.UseCases.Create
  alias YouSpeak.Groups.Schemas.Group

  # doctest YouSpeak.Groups.UseCases.Create

  def group_factory(attributes \\ %{}), do: Factory.insert!(:group, attributes)
  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)

  defp add_teacher_id(group_params, teacher_id),
    do: Map.put(group_params, :teacher_id, teacher_id)

  setup do
    teacher = teacher_factory()

    {:ok, teacher: teacher}
  end

  test "call/1 with blank name must return changeset error", %{teacher: teacher} do
    group_params = %{name: ""}
    params = add_teacher_id(group_params, teacher.id)

    {:error, changeset} = Create.call(params)

    assert "can't be blank" in errors_on(changeset).name
  end

  test "call/1 with valid data must create a group", %{teacher: teacher} do
    group_params = %{
      name: "Test",
      description: "Description"
    }

    params = add_teacher_id(group_params, teacher.id)

    {:ok, group} = Create.call(params)

    assert group.name == group_params.name
    assert group.description == group_params.description
    refute is_nil(group.activated_at)
    assert is_nil(group.inactivated_at)
    assert group.teacher_id == teacher.id
    assert Group.active?(group)
  end
end
