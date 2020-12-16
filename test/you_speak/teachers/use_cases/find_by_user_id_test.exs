defmodule YouSpeak.Teachers.UseCases.FindByUserIDTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Teachers.UseCases.FindByUserID

  doctest YouSpeak.Teachers.UseCases.FindByUserID

  def user_factory(attributes \\ %{}), do: Factory.insert!(:user, attributes)
  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)

  test "call/1 with invalid user_id must raise not found" do
    assert is_nil(FindByUserID.call(999_999))
  end

  test "call/1 with valid data user_id must return record" do
    user = user_factory()
    teacher = teacher_factory(%{user_id: user.id})

    result = FindByUserID.call(user.id)

    assert result.id == teacher.id
    assert result.user_id == user.id
  end
end
