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
    test "with valid id must return a group", %{conn: conn, teacher: teacher} do
      group = group_factory(%{teacher_id: teacher.id})
      conn = get(conn, Routes.group_path(conn, :show, group))

      assert html_response(conn, 200) =~ group.name
    end

    # test "with invalid id must raise 404", %{conn: conn} do
    #   group = group_factory()
    #   conn = get(conn, Routes.group_path(conn, :show, group))
    #
    #   assert html_response(conn, 200) =~ group.name
    # end
  end
end
