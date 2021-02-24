defmodule YouSpeakWeb.Meetings.MeetingControllerTest do
  use YouSpeakWeb.ConnCase

  alias YouSpeak.Factory

  def user_factory, do: Factory.insert!(:user)
  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)
  def group_factory(attributes \\ %{}), do: Factory.build(:group, attributes)
  def meeting_factory(attributes \\ %{}), do: Factory.insert!(:meeting, attributes)

  setup %{conn: conn} do
    user = user_factory()
    teacher = teacher_factory(%{user_id: user.id})

    {:ok, group} =
      group_factory()
      |> YouSpeak.Groups.Schemas.Group.changeset(%{name: "My name", teacher_id: teacher.id})
      |> YouSpeak.Repo.insert()

    conn =
      conn
      |> Plug.Test.init_test_session(user_id: user.id)
      |> YouSpeakWeb.Plugs.SetUser.call(%{})

    {:ok, conn: conn, teacher: teacher, group: group}
  end

  test "GET /groups/:group_id/meetings/new", %{conn: conn, group: group} do
    conn = get(conn, Routes.group_meeting_path(conn, :new, group))

    assert html_response(conn, 200) =~ "Add meeting"
  end
end
