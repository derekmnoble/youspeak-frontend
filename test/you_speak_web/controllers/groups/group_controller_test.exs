defmodule YouSpeakWeb.Groups.GroupControllerTest do
  use YouSpeakWeb.ConnCase

  alias YouSpeak.Factory

  def user_factory, do: Factory.insert!(:user)
  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)
  def group_factory(attributes \\ %{}), do: Factory.insert!(:group, attributes)

  @valid_params %{
    name: "Name",
    description: "description"
  }
  @invalid_params %{
    name: "",
    namespace: "namespace",
    description: "",
    url: ""
  }

  setup %{conn: conn} do
    user = user_factory()
    teacher = teacher_factory(%{user_id: user.id})

    conn =
      conn
      |> Plug.Test.init_test_session(user_id: user.id)
      |> YouSpeakWeb.Plugs.SetUser.call(%{})

    {:ok, conn: conn, teacher: teacher}
  end

  test "GET /groups", %{conn: conn} do
    conn = get(conn, Routes.group_path(conn, :index))

    assert html_response(conn, 200) =~ "Listing groups"
  end

  test "GET /groups/new", %{conn: conn} do
    conn = get(conn, Routes.group_path(conn, :new))

    assert html_response(conn, 200) =~ "Add group"
  end

  describe "POST /groups" do
    test "with valid data must create a new group and redirect to page path", %{conn: conn} do
      conn = post(conn, Routes.group_path(conn, :create), group: @valid_params)

      assert get_flash(conn, :info) == "Group created!"
      assert redirected_to(conn) == Routes.group_path(conn, :index)
    end

    test "with invalid data render errors and keep in the new page", %{conn: conn} do
      conn = post(conn, Routes.group_path(conn, :create), group: @invalid_params)

      assert html_response(conn, 200) =~ "Add group"
    end
  end

  describe "GET /groups/1" do
    test "with valid id must open show template with group", %{conn: conn, teacher: teacher} do
      group = group_factory(%{teacher_id: teacher.id})
      conn = get(conn, Routes.group_path(conn, :show, group))

      assert html_response(conn, 200) =~ group.name
      assert html_response(conn, 200) =~ "Group details"
    end

    test "with invalid id must raise 404", %{conn: conn} do
      conn = get(conn, Routes.group_path(conn, :show, %YouSpeak.Groups.Schemas.Group{id: 99}))

      assert html_response(conn, 404)
    end
  end

  describe "GET /groups/1/edit" do
    test "with valid id must open edit template with group", %{conn: conn, teacher: teacher} do
      group = group_factory(%{teacher_id: teacher.id})
      conn = get(conn, Routes.group_path(conn, :edit, group))

      assert html_response(conn, 200) =~ group.name
      assert html_response(conn, 200) =~ "Edit group"
    end

    test "with invalid id must raise 404", %{conn: conn} do
      conn = get(conn, Routes.group_path(conn, :edit, %YouSpeak.Groups.Schemas.Group{id: 99}))

      assert html_response(conn, 404)
    end
  end

  describe "PUT /topics/ID" do
    test "with valid data must update the group data and redirect to index", %{
      conn: conn,
      teacher: teacher
    } do
      group = group_factory(%{teacher_id: teacher.id})
      params = %{name: "Other name"}

      conn = put(conn, Routes.group_path(conn, :update, group), group: params)

      assert get_flash(conn, :info) == "Group updated"
      assert redirected_to(conn) == Routes.group_path(conn, :index)
    end

    # test "with invalid data must not update topic and stay in form", %{conn: conn} do
    #   topic = topic_factory(%{user: conn.assigns.user})
    #
    #   conn = put(conn, topic_path(conn, :update, topic), topic: @invalid_params)
    #
    #   assert html_response(conn, 200) =~ "Edit Topic"
    # end
    #
    # test "redirect to root when current user is not topic owner", %{conn: conn} do
    #   user_one = user_factory()
    #   user_two = user_factory()
    #   topic = topic_factory(%{user: user_one})
    #
    #   conn =
    #     conn
    #     |> Plug.Test.init_test_session(user_id: user_two.id)
    #     |> DiscussWeb.Plugs.SetUser.call(%{})
    #     |> put(topic_path(conn, :update, topic), topic: @valid_params)
    #
    #   assert get_flash(conn, :error) == "You're not the owner of this topic!"
    #   assert redirected_to(conn) == topic_path(conn, :index)
    #   assert conn.halted()
    # end
  end
end
