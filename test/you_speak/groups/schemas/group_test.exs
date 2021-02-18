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

  describe "activate/0" do
    test "must activate a group" do
      group = group_factory(%{activated_at: nil, inactivated_at: ~N[2020-12-01 12:00:00]})

      changeset = Group.activate(group)

      refute is_nil(Ecto.Changeset.get_change(changeset, :activated_at))
      assert is_nil(Ecto.Changeset.get_change(changeset, :inactivated_at))
    end
  end

  describe "inactivate/0" do
    test "must inactivate a group" do
      changeset =
        %{activated_at: ~N[2020-12-01 12:00:00], inactivated_at: nil}
        |> group_factory()
        |> Group.inactivate()

      assert is_nil(Ecto.Changeset.get_change(changeset, :activated_at))
      refute is_nil(Ecto.Changeset.get_change(changeset, :inactivated_at))
    end
  end

  test "return error when try to update the teacher_id" do
    group = Factory.insert!(:group, %{teacher_id: Factory.insert!(:teacher).id})
    new_teacher = Factory.insert!(:teacher)

    {:ok, updated_group} =
      group
      |> Group.changeset(%{teacher_id: new_teacher.id})
      |> Repo.update()

    assert group.teacher_id == updated_group.teacher_id
    refute group.teacher_id == new_teacher.id
  end

  test "slugify name" do
    changeset =
      group_factory()
      |> Group.changeset(%{name: "my name"})

    assert Ecto.Changeset.get_field(changeset, :slug) == "my-name"

    changeset =
      group_factory()
      |> Group.changeset(%{name: "my name    otherNAME"})

    assert Ecto.Changeset.get_field(changeset, :slug) == "my-name-othername"

    changeset =
      group_factory()
      |> Group.changeset(%{name: "1-my xpa c"})

    assert Ecto.Changeset.get_field(changeset, :slug) == "1-my-xpa-c"
  end

  # test "name slug must be unique" do
  #   schema =
  #     Factory.insert!(:teacher, %{
  #       name: "name-#{System.unique_integer()}",
  #       name: "name",
  #       description: "",
  #       url: ""
  #     })
  #
  #   other_schema = group_factory(%{name: schema.name})
  #
  #   {:error, other_changeset} =
  #     other_schema
  #     |> Group.changeset(%{})
  #     |> Repo.insert()
  #
  #   assert "has already been taken" in errors_on(other_changeset).name
  #
  #   {:ok, _schema} =
  #     group_factory(%{name: "test name"})
  #     |> Group.changeset(%{})
  #     |> Repo.insert()
  # end
end
