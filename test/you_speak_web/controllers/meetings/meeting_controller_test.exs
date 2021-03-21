defmodule YouSpeakWeb.Meetings.MeetingControllerTest do
  use YouSpeakWeb.ConnCase

  alias YouSpeak.Factory
  alias YouSpeak.Meetings.Schemas.Meeting

  def user_factory, do: Factory.insert!(:user)
  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)
  def group_factory(attributes \\ %{}), do: Factory.build(:group, attributes)
  def meeting_factory(attributes \\ %{}), do: Factory.insert!(:meeting, attributes)

  @valid_params %{
    name: "Meeting",
    description: "",
    video_url: "https://www.youtube.com/watch?v=2d_6EQx3Z84"
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

  describe "GET /groups/:group_id/meetings" do
    test "renders meetings/index template given a valid group", %{conn: conn, group: group} do
      meeting_factory(%{group_id: group.id})
      conn = get(conn, Routes.group_meeting_path(conn, :index, group))

      assert html_response(conn, 200) =~ "Group #{group.name} meetings"
    end

    test "renders meetings/index with no meetings show empty index", %{conn: conn, group: group} do
      conn = get(conn, Routes.group_meeting_path(conn, :index, group))

      assert html_response(conn, 200) =~ "You have no meetings for group: #{group.name}"
    end

    test "renders 404 given an invalid group", %{conn: conn} do
      conn =
        get(
          conn,
          Routes.group_meeting_path(
            conn,
            :index,
            %YouSpeak.Groups.Schemas.Group{id: 99, slug: "99"},
            meeting: @valid_params
          )
        )

      assert html_response(conn, 404)
    end
  end

  describe "GET /groups/:group_id/meetings/new" do
    test "renders meetings/new template given a valid group", %{conn: conn, group: group} do
      conn = get(conn, Routes.group_meeting_path(conn, :new, group))

      assert html_response(conn, 200) =~ "Add meeting"
    end

    test "renders 404 given an invalid group", %{conn: conn} do
      conn =
        get(
          conn,
          Routes.group_meeting_path(
            conn,
            :new,
            %YouSpeak.Groups.Schemas.Group{id: 99, slug: "99"},
            meeting: @valid_params
          )
        )

      assert html_response(conn, 404)
    end
  end

  describe "GET /groups/slug/meetings/slug" do
    test "with valid id/slug must open show template with meeting", %{conn: conn, group: group} do
      params = %{
        name: "My Meeting",
        video_url: "https://www.youtube.com/watch?v=2d_6EQx3Z84",
        description: "",
        group_id: group.id
      }

      {:ok, meeting} =
        %Meeting{}
        |> Meeting.changeset(params)
        |> YouSpeak.Repo.insert()

      conn = get(conn, Routes.group_meeting_path(conn, :show, group, meeting))

      assert html_response(conn, 200) =~ meeting.name
      assert html_response(conn, 200) =~ "Meeting details"
    end

    test "with invalid id must raise 404", %{conn: conn, group: group} do
      conn =
        get(
          conn,
          Routes.group_meeting_path(conn, :show, group, %YouSpeak.Meetings.Schemas.Meeting{
            id: 99,
            slug: "99"
          })
        )

      assert html_response(conn, 404)
    end
  end

  describe "POST /groups/:group_id/meetings" do
    test "with valid data must create a new meeting and redirect to group path", %{
      conn: conn,
      group: group
    } do
      conn =
        post(conn, Routes.group_meeting_path(conn, :create, group.id), meeting: @valid_params)

      assert get_flash(conn, :info) == "Meeting created!"
      assert redirected_to(conn) == Routes.group_path(conn, :index)
    end

    test "with invalid data render errors and keep in the new page", %{conn: conn, group: group} do
      conn =
        post(conn, Routes.group_meeting_path(conn, :create, group.id), meeting: @invalid_params)

      assert html_response(conn, 200) =~ "Add meeting"
    end

    test "with invalid group_id must raise 404", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.group_meeting_path(
            conn,
            :create,
            %YouSpeak.Groups.Schemas.Group{id: 99, slug: "99"},
            meeting: @valid_params
          )
        )

      assert html_response(conn, 404)
    end
  end

  describe "GET /groups/:group_id/meetings/:meeting_id/edit" do
    test "with valid id/slug must open edit template with meeting", %{conn: conn, group: group} do
      meeting = meeting_factory(%{group_id: group.id, slug: "myslug"})
      conn = get(conn, Routes.group_meeting_path(conn, :edit, group.slug, meeting.slug))

      assert html_response(conn, 200) =~ meeting.name
      assert html_response(conn, 200) =~ "Edit meeting"
    end

    test "with invalid id must raise 404", %{conn: conn, group: group} do
      conn =
        get(
          conn,
          Routes.group_meeting_path(conn, :edit, group, %YouSpeak.Meetings.Schemas.Meeting{
            id: 99,
            slug: "xunda"
          })
        )

      assert html_response(conn, 404)
    end
  end

  describe "PUT /groups/ID/meetings" do
    test "with valid data must update the group data and redirect to meetings index", %{
      conn: conn,
      group: group
    } do
      params = %{
        name: "My Meeting",
        video_url: "https://www.youtube.com/watch?v=2d_6EQx3Z84",
        description: "",
        group_id: group.id
      }

      {:ok, meeting} =
        %Meeting{}
        |> Meeting.changeset(params)
        |> YouSpeak.Repo.insert()

      conn =
        put(conn, Routes.group_meeting_path(conn, :update, group, meeting),
          meeting: %{params | name: "My new Name"}
        )

      assert get_flash(conn, :info) == "Meeting updated"
      assert redirected_to(conn) == Routes.group_meeting_path(conn, :index, group)
    end

    test "with invalid data must keeps on edit page", %{
      conn: conn,
      group: group
    } do
      params = %{
        name: "My Meeting",
        video_url: "https://www.youtube.com/watch?v=2d_6EQx3Z84",
        description: "",
        group_id: group.id
      }

      {:ok, meeting} =
        %Meeting{}
        |> Meeting.changeset(params)
        |> YouSpeak.Repo.insert()

      conn =
        put(conn, Routes.group_meeting_path(conn, :update, group, meeting),
          meeting: %{params | video_url: ""}
        )

      assert html_response(conn, 200) =~ "Edit meeting"
    end
  end
end
