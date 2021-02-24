defmodule YouSpeakWeb.Meetings.MeetingControllerTest do
  use YouSpeakWeb.ConnCase

  alias YouSpeak.Factory

  def user_factory, do: Factory.insert!(:user)
  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)
  def group_factory(attributes \\ %{}), do: Factory.build(:group, attributes)
  def meeting_factory(attributes \\ %{}), do: Factory.insert!(:meeting, attributes)

  @valid_params %{
    name: "Meeting",
    description: "",
    video_url: "video_url",
  }

  @invalid_params %{
    name: "",
    description: "",
    video_url: ""
  }

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

  describe "POST /groups/:group_id/meetings" do
    test "with valid data must create a new meeting and redirect to group path", %{conn: conn, group: group} do
      conn = post(conn, Routes.group_meeting_path(conn, :create, group.id), meeting: @valid_params)

      assert get_flash(conn, :info) == "Meeting created!"
      assert redirected_to(conn) == Routes.group_path(conn, :index)
    end

    test "with invalid data render errors and keep in the new page", %{conn: conn, group: group} do
      conn = post(conn, Routes.group_meeting_path(conn, :create, group.id), meeting: @invalid_params)

      assert html_response(conn, 200) =~ "Add meeting"
    end

    @tag :skip
    test "when group is not valid"
  end
end
