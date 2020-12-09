defmodule YouSpeakWeb.Teachers.RegistrationControllerTest do
  use YouSpeakWeb.ConnCase

  alias YouSpeak.Factory

  def user_factory, do: Factory.insert!(:user)
  def teacher_factory(attributes), do: Factory.insert!(:teacher, attributes)

  @valid_params %{
    name: "Name",
    namespace: "namespace",
    description: "",
    url: ""
  }
  @invalid_params %{
    name: "",
    namespace: "namespace",
    description: "",
    url: ""
  }

  setup %{conn: conn} do
    user_data = user_factory()

    conn =
      conn
      |> Plug.Test.init_test_session(user_id: user_data.id)
      |> YouSpeakWeb.Plugs.SetUser.call(%{})

    {:ok, conn: conn}
  end

  test "GET /teachers/registration/new", %{conn: conn} do
    conn = get(conn, Routes.registration_path(conn, :new))

    assert html_response(conn, 200) =~ "Complete your registration"
  end

  test "GET /teachers/registrarion/new redirect to page_path when teacher already exists", %{conn: conn} do
    teacher_factory(%{user_id: conn.assigns[:user].id})

    conn = get(conn, Routes.registration_path(conn, :new))

    assert redirected_to(conn) == Routes.page_path(conn, :index)
  end

  describe "POST /teachers/registrarion" do
    test "with valid data must create a new teacher and redirect to page path", %{
      conn: conn
    } do
      conn = post(conn, Routes.registration_path(conn, :create), teacher: @valid_params)

      assert get_flash(conn, :info) == "Registration completed!"
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "with invalid data render errors and keep in the new page", %{conn: conn} do
      conn = post(conn, Routes.registration_path(conn, :create), teacher: @invalid_params)

      assert html_response(conn, 200) =~ "Complete your registration"
    end
  end
end
