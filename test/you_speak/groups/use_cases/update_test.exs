defmodule YouSpeak.Groups.UseCases.UpdateTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Groups.UseCases.Update

  # doctest YouSpeak.Groups.UseCases.Update

  def group_factory(attributes \\ %{}), do: Factory.insert!(:group, attributes)

  test "call/2 with valid data must update the content" do
    group = group_factory()
    new_params = %{
      name: "updated name",
      description: "updated desc"
    }

    {:ok, updated_group} = Update.call(group.id, new_params)

    assert updated_group.id == group.id
    assert updated_group.name == new_params.name
    assert updated_group.description == new_params.description
  end

  test "call/2 with invalid return changeset" do
    group = group_factory()
    new_params = %{
      name: "",
      description: "updated desc"
    }

    {:error, changeset} = Update.call(group.id, new_params)

    assert "can't be blank" in errors_on(changeset).name
  end

  test "call/2 with invalid record error" do
    assert {:error, "invalid id"} = Update.call(999, %{name: "updated test"})
  end
end
