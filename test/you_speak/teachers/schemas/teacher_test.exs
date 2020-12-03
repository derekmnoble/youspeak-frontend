defmodule YouSpeak.Teachers.Schemas.TeacherTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Teachers.Schemas.Teacher
  alias YouSpeak.Repo

  def teacher_factory(attributes \\ %{}), do: Factory.build(:teacher, attributes)

  test "return valid true when data is valid" do
    changeset =
      teacher_factory()
      |> Teacher.changeset(%{})

    assert changeset.valid?
  end

  describe "validations" do
    test "name must not be blank" do
      changeset =
        teacher_factory()
        |> Teacher.changeset(%{name: ""})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).name
    end

    test "name must not be nil" do
      changeset =
        teacher_factory()
        |> Teacher.changeset(%{name: nil})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).name
    end

    test "name must not be higher than 200 chars" do
      changeset =
        teacher_factory()
        |> Teacher.changeset(%{name: String.duplicate("a", 201)})

      refute changeset.valid?
      assert "should be at most 200 character(s)" in errors_on(changeset).name
    end

    test "namespace must not be blank" do
      changeset =
        teacher_factory()
        |> Teacher.changeset(%{namespace: ""})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).namespace
    end

    test "namespace must not be nil" do
      changeset =
        teacher_factory()
        |> Teacher.changeset(%{namespace: nil})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).namespace
    end

    test "namespace must not be higher than 200 chars" do
      changeset =
        teacher_factory()
        |> Teacher.changeset(%{namespace: String.duplicate("a", 201)})

      refute changeset.valid?
      assert "should be at most 200 character(s)" in errors_on(changeset).namespace
    end

    test "slugify namespace" do
      changeset =
        teacher_factory()
        |> Teacher.changeset(%{namespace: "my name Space"})

      assert Ecto.Changeset.get_field(changeset, :namespace) == "my-name-space"

      changeset =
        teacher_factory()
        |> Teacher.changeset(%{namespace: "my name    otherSPACE"})

      assert Ecto.Changeset.get_field(changeset, :namespace) == "my-name-otherspace"

      changeset =
        teacher_factory()
        |> Teacher.changeset(%{namespace: "1-my xpa c"})

      assert Ecto.Changeset.get_field(changeset, :namespace) == "1-my-xpa-c"
    end

    test "namespace slug must be unique" do
      schema =
        Factory.insert!(:teacher, %{
          name: "name-#{System.unique_integer()}",
          namespace: "namespace",
          description: "",
          url: ""
        })

      other_schema = teacher_factory(%{namespace: schema.namespace})

      {:error, other_changeset} =
        other_schema
        |> Teacher.changeset(%{})
        |> Repo.insert()

      assert "has already been taken" in errors_on(other_changeset).namespace

      {:ok, _} =
        teacher_factory(%{namespace: "test namespace"})
        |> Teacher.changeset(%{})
        |> Repo.insert()
    end
  end
end
