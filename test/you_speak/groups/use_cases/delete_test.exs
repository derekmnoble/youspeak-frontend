defmodule YouSpeak.Groups.UseCases.DeleteTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Groups.UseCases.Delete

  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)
  def group_factory(attributes \\ %{}), do: Factory.insert!(:group, attributes)

  test "call/1 with existent record must delete" do
    group = group_factory(%{teacher_id: teacher_factory().id})

    assert {:ok, _schema} = Delete.call(group, group.teacher_id)
  end

  test "call/1 with existent and wrong teacher must raise error" do
    group = group_factory(%{teacher_id: teacher_factory().id})

    assert {:error, _changeset} = Delete.call(group, teacher_factory().id)
  end
end
