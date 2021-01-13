defmodule YouSpeak.Groups.UseCases.GetTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Groups.UseCases.Get

  doctest YouSpeak.Groups.UseCases.Get

  def group_factory(attributes \\ %{}), do: Factory.insert!(:group, attributes)

  test "call/1 with an existent group" do
    group = group_factory()

    result = Get.call(group.id)

    assert result.id == group.id
  end

  test "call/1 with invalid group returns nil" do
    assert is_nil(Get.call(999_999))
  end
end
