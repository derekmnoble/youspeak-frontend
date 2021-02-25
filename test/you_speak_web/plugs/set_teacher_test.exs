defmodule YouSpeakWeb.Plugs.SetTeacherTest do
  use YouSpeakWeb.ConnCase

  alias YouSpeak.Factory
  alias YouSpeakWeb.Plugs.SetTeacher

  def user_factory, do: Factory.insert!(:user)
  def teacher_factory(), do: Factory.build(:teacher)

  test "init/1 must return params" do
    assert nil == SetTeacher.init(%{})
  end

  test "call/2 with user in sessions must assigns teacher to conn assings struct", %{conn: conn} do
    user = user_factory()
    {:ok, teacher} =
      teacher_factory()
      |> YouSpeak.Teachers.Schemas.Teacher.changeset(%{user_id: user.id})
      |> YouSpeak.Repo.insert()

    conn =
      conn
      |> Plug.Test.init_test_session(user_id: user.id)
      |> YouSpeakWeb.Plugs.SetUser.call(%{})

    assert %{assigns: %{teacher: current_teacher}} = SetTeacher.call(conn, %{})

    assert current_teacher.id == teacher.id
  end

  test "call/2 without user in sessions must assigns NIL to conn assings struct", %{conn: conn} do
    conn =
      conn
      |> Plug.Test.init_test_session(user_id: nil)
      |> YouSpeakWeb.Plugs.SetUser.call(%{})

    assert %{assigns: %{teacher: current_teacher}} = SetTeacher.call(conn, %{})

    assert is_nil(current_teacher)
  end
end
