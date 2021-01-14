defmodule YouSpeak.Groups.UseCases.DeleteTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Groups.UseCases.Delete

  def group_factory(attributes \\ %{}), do: Factory.insert!(:group, attributes)

  test "call/1 with existent record must delete" do
    group = group_factory()

    assert {:ok, _} = Delete.call(group)
  end
end
