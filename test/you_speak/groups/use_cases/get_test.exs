defmodule YouSpeak.Groups.UseCases.GetTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Groups.UseCases.Get

  doctest YouSpeak.Groups.UseCases.Get

  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)
  def group_factory(attributes \\ %{}), do: Factory.insert!(:group, attributes)

  test "call/1 with an existent group" do
    group = group_factory(%{teacher_id: teacher_factory().id})
    params = %{group_id: group.id, teacher_id: group.teacher_id}

    result = Get.call(params)

    assert result.id == group.id
  end

  test "call/1 with invalid group returns nil" do
    assert is_nil(Get.call(%{group_id: 999_999, teacher_id: teacher_factory().id}))
  end
end
