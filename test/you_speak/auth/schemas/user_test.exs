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
    test "role must not be nil" do
      changeset =
        user_factory()
        |> User.changeset(%{role: nil})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).role
    end

    test "role must not be invalid" do
      changeset =
        user_factory()
        |> User.changeset(%{role: "xunda"})

      refute changeset.valid?
      assert "is invalid" in errors_on(changeset).role

      changeset =
        user_factory()
        |> User.changeset(%{role: "teacher"})

      assert changeset.valid?

      changeset =
        user_factory()
        |> User.changeset(%{role: "student"})

      assert changeset.valid?

      changeset =
        user_factory()
        |> User.changeset(%{role: "admin"})

      assert changeset.valid?
    end

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
end
