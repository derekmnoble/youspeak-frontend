defmodule YouSpeakWeb.Meetings.CommentControllerTest do
  use YouSpeakWeb.ConnCase

  alias YouSpeak.Factory
  # alias YouSpeak.Meetings.Schemas.Comment

  def user_factory, do: Factory.insert!(:user)
  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)
  def group_factory(attributes \\ %{}), do: Factory.build(:group, attributes)
  def meeting_factory(attributes \\ %{}), do: Factory.build(:meeting, attributes)

  @valid_params %{
    url: "some_path"
  }

  # @invalid_params %{
  #   url: ""
  # }

  setup %{conn: conn} do
    user = user_factory()
    teacher = teacher_factory(%{user_id: user.id})

    {:ok, group} =
      group_factory()
      |> YouSpeak.Groups.Schemas.Group.changeset(%{name: "Group name", teacher_id: teacher.id})
      |> YouSpeak.Repo.insert()

    {:ok, meeting} =
      meeting_factory()
      |> YouSpeak.Meetings.Schemas.Meeting.changeset(%{
        name: "Meeting name",
        video_url: "https://www.youtube.com/watch?v=2d_6EQx3Z84",
        group_id: group.id
      })
      |> YouSpeak.Repo.insert()

    conn =
      conn
      |> Plug.Test.init_test_session(user_id: user.id)
      |> YouSpeakWeb.Plugs.SetUser.call(%{})

    {:ok, conn: conn, teacher: teacher, group: group, meeting: meeting}
  end

  describe "POST /groups/:group_id/meetings/:meeting_id/comments" do
    test "with valid data must create a new meeting and return :ok", %{
      conn: conn,
      group: group,
      meeting: meeting
    } do
      conn =
        post(conn, Routes.comment_path(conn, :create, group, meeting), comment: @valid_params)

      assert json_response(conn, 201)
    end
  end
end
