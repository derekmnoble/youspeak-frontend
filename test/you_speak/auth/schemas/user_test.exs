defmodule YouSpeak.Auth.Schemas.UserTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Auth.Schemas.User
  alias YouSpeak.Repo

  def user_factory(attributes \\ %{}) do
    Factory.build(:user, attributes)
  end

  test "return valid true when data is valid" do
    changeset =
      user_factory()
      |> User.changeset(%{})

    assert changeset.valid?
  end

  test "set teacher as default role" do
    user = Factory.insert!(:user)

    assert user.role == "teacher"
  end

  describe "validations" do
    test "email must not be blank" do
      changeset =
        user_factory()
        |> User.changeset(%{email: ""})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).email
    end

    test "email must not be nil" do
      changeset =
        user_factory()
        |> User.changeset(%{email: nil})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).email
    end

    test "email must not be a invalid format" do
      changeset =
        user_factory()
        |> User.changeset(%{email: "email@com"})

      refute changeset.valid?
      assert "has invalid format" in errors_on(changeset).email
    end

    test "email must be unique" do
      schema = Factory.insert!(:user, %{email: "email@example.org"})
      other_schema = user_factory(%{email: schema.email})

      {:error, other_changeset} =
        other_schema
        |> User.changeset(%{})
        |> Repo.insert()

      assert "has already been taken" in errors_on(other_changeset).email

      {:ok, _} =
        user_factory(%{email: "other@email.com"})
        |> User.changeset(%{})
        |> Repo.insert()
    end

    test "provider must not be blank" do
      changeset =
        user_factory()
        |> User.changeset(%{provider: ""})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).provider
    end

    test "provider must not be nil" do
      changeset =
        user_factory()
        |> User.changeset(%{provider: nil})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).provider
    end

    test "token must not be blank" do
      changeset =
        user_factory()
        |> User.changeset(%{token: ""})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).token
    end

    test "token must not be nil" do
      changeset =
        user_factory()
        |> User.changeset(%{token: nil})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).token
    end
  end
  #
  # describe "user schema validations" do
  #
  #
  #   test "email must be unique" do
  #     schema = Factory.insert(:user, %{name: "name", email: "email@example.org"})
  #     other_schema = student_factory(%{email: schema.email})
  #
  #     {:error, other_changeset} =
  #       other_schema
  #       |> User.changeset(%{})
  #       |> Repo.insert()
  #
  #     assert "has already been taken" in errors_on(other_changeset).email
  #
  #     {:ok, _} =
  #       student_factory(%{email: "other@email.com"})
  #       |> User.changeset(%{})
  #       |> Repo.insert()
  #   end
  #
  #   test "role must not be nil" do
  #     changeset =
  #       student_factory()
  #       |> User.changeset(%{role: nil})
  #
  #     refute changeset.valid?
  #     assert "can't be blank" in errors_on(changeset).role
  #   end
  #
  #   test "role must not be invalid" do
  #     changeset =
  #       student_factory()
  #       |> User.changeset(%{role: "xunda"})
  #
  #     refute changeset.valid?
  #     assert "is invalid" in errors_on(changeset).role
  #
  #     changeset =
  #       student_factory()
  #       |> User.changeset(%{role: "teacher"})
  #
  #     assert changeset.valid?
  #
  #     changeset =
  #       student_factory()
  #       |> User.changeset(%{role: "student"})
  #
  #     assert changeset.valid?
  #
  #     changeset =
  #       student_factory()
  #       |> User.changeset(%{role: "admin"})
  #
  #     assert changeset.valid?
  #   end
  #
  #   test "default role must be student" do
  #     user = student_factory()
  #     changeset = User.changeset(user, %{role: ""})
  #
  #     assert changeset.valid?
  #     assert user.role == "student"
  #   end
  #
  #   test "namespace is required when role is teacher" do
  #     changeset =
  #       teacher_factory()
  #       |> User.changeset(%{namespace: ""})
  #
  #     refute changeset.valid?
  #     assert "can't be blank" in errors_on(changeset).namespace
  #   end
  #
  #   test "namespace must not be higher than 120 chars" do
  #     changeset =
  #       teacher_factory()
  #       |> User.changeset(%{namespace: String.duplicate("a", 121)})
  #
  #     refute changeset.valid?
  #     assert "should be at most 120 character(s)" in errors_on(changeset).namespace
  #   end
  #
  #   test "slugify namespace" do
  #     changeset =
  #       teacher_factory()
  #       |> User.changeset(%{namespace: "my name Space"})
  #
  #     assert Ecto.Changeset.get_field(changeset, :namespace) == "my-name-space"
  #
  #     changeset =
  #       teacher_factory()
  #       |> User.changeset(%{namespace: "my name    otherSPACE"})
  #
  #     assert Ecto.Changeset.get_field(changeset, :namespace) == "my-name-otherspace"
  #
  #     changeset =
  #       teacher_factory()
  #       |> User.changeset(%{namespace: "1-my xpa c"})
  #
  #     assert Ecto.Changeset.get_field(changeset, :namespace) == "1-my-xpa-c"
  #   end
  #
  #   test "namespace slug must be unique" do
  #     schema =
  #       Factory.insert(:user, %{
  #         role: "teacher",
  #         namespace: "my namespace",
  #         email: "name@email.com"
  #       })
  #
  #     other_schema = teacher_factory(%{namespace: schema.namespace})
  #
  #     {:error, other_changeset} =
  #       other_schema
  #       |> User.changeset(%{})
  #       |> Repo.insert()
  #
  #     assert "has already been taken" in errors_on(other_changeset).namespace
  #
  #     {:ok, _} =
  #       teacher_factory(%{namespace: "test namespace"})
  #       |> User.changeset(%{})
  #       |> Repo.insert()
  #   end
  # end
end
