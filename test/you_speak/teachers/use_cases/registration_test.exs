defmodule YouSpeak.Teachers.UseCases.RegistrationTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Teachers.UseCases.Registration

  def user_factory(attributes \\ %{}), do: Factory.insert!(:user, attributes)
  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)

  test "call/1 with blank name and namespace must return changeset error" do
    params = %{
      name: "",
      namespace: "",
      description: "",
      url: "http://pudim.com.br"
    }

    {:error, changeset} = Registration.call(params)

    assert "can't be blank" in errors_on(changeset).name
    assert "can't be blank" in errors_on(changeset).namespace
  end

  test "call/1 with namespace must return changeset error" do
    params = %{
      name: "Name",
      namespace: "",
      description: "",
      url: ""
    }

    {:error, changeset} = Registration.call(params)
    assert "can't be blank" in errors_on(changeset).namespace
  end

  test "call/1 with already used namespace must return changeset error" do
    _teacher = teacher_factory(%{namespace: "test"})

    params = %{
      name: "Name",
      namespace: "test",
      description: "",
      url: ""
    }

    {:error, changeset} = Registration.call(params)
    assert "has already been taken" in errors_on(changeset).namespace
  end

  test "call/1 with valid data must create a new teacher" do
    current_user = user_factory()

    params = %{
      name: "Name",
      namespace: "namespace",
      description: "description",
      url: "http://www.pudim.com.br",
      user_id: current_user.id
    }

    {:ok, teacher} = Registration.call(params)

    assert teacher.name == params.name
    assert teacher.namespace == params.namespace
    assert teacher.description == params.description
    assert teacher.url == params.url
    assert teacher.user_id == current_user.id
  end
end
