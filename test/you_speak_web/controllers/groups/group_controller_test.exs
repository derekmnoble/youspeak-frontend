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

  describe "GET /groups/slug" do
    test "with valid id/slug must open show template with group", %{conn: conn, teacher: teacher} do
      group = group_factory(%{teacher_id: teacher.id, slug: "myslug"})
      conn = get(conn, Routes.group_path(conn, :show, group.slug))

      assert html_response(conn, 200) =~ group.name
      assert html_response(conn, 200) =~ "Group details"
    end

    test "with invalid id must raise 404", %{conn: conn} do
      conn = get(conn, Routes.group_path(conn, :show, %YouSpeak.Groups.Schemas.Group{id: 99, slug: "99"}))

      assert html_response(conn, 404)
    end
  end

  describe "GET /groups/slug/edit" do
    test "with valid id/slug must open edit template with group", %{conn: conn, teacher: teacher} do
      group = group_factory(%{teacher_id: teacher.id, slug: "myslug"})
      conn = get(conn, Routes.group_path(conn, :edit, group.slug))

      assert html_response(conn, 200) =~ group.name
      assert html_response(conn, 200) =~ "Edit group"
    end

    test "with invalid id must raise 404", %{conn: conn} do
      conn = get(conn, Routes.group_path(conn, :edit, %YouSpeak.Groups.Schemas.Group{id: 99}))

      assert html_response(conn, 404)
    end
  end

  describe "PUT /groups/ID" do
    test "with valid data must update the group data and redirect to index", %{
      conn: conn,
      teacher: teacher
    } do
      group = group_factory(%{teacher_id: teacher.id})
      params = %{name: "Other name"}

      conn = put(conn, Routes.group_path(conn, :update, group.id), group: params)

      assert get_flash(conn, :info) == "Group updated"
      assert redirected_to(conn) == Routes.group_path(conn, :index)
    end
  end
end
