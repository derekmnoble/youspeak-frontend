defmodule YouSpeak.Groups.Schemas.GroupTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Groups.Schemas.Group

  def group_factory(attributes \\ %{}), do: Factory.build(:group, attributes)

  test "return valid true when data is valid" do
    changeset =
      group_factory()
      |> Group.changeset(%{})

    assert changeset.valid?
  end

  describe "validations" do
    test "name must not be blank" do
      changeset =
        group_factory()
        |> Group.changeset(%{name: ""})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).name
    end

    test "name must not be nil" do
      changeset =
        group_factory()
        |> Group.changeset(%{name: nil})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).name
    end

    test "name must not be higher than 200 chars" do
      changeset =
        group_factory()
        |> Group.changeset(%{name: String.duplicate("a", 201)})

      refute changeset.valid?
      assert "should be at most 200 character(s)" in errors_on(changeset).name
    end

    test "description must not be blank" do
      changeset =
        group_factory()
        |> Group.changeset(%{description: ""})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).description
    end

    test "description must not be nil" do
      changeset =
        group_factory()
        |> Group.changeset(%{description: nil})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).description
    end
  end

  describe "active?/0" do
    test "when activated_at is filled and inactivated_at is nil" do
      group = group_factory()

      assert Group.active?(group)
    end

    test "when activated_at is not filled" do
      group = group_factory(%{activated_at: nil})

      refute Group.active?(group)
    end
  end
end
