defmodule YouSpeakWeb.Teachers.RegistrationControllerTest do
  use YouSpeakWeb.ConnCase

  alias YouSpeak.Factory

  def user_factory, do: Factory.insert!(:user)
  def teacher_factory(attributes), do: Factory.insert!(:teacher, attributes)

  # @valid_params %{title: "My Title"}
  # @invalid_params %{title: ""}

  setup %{conn: conn} do
    user_data = user_factory()

    conn =
      conn
      |> Plug.Test.init_test_session(user_id: user_data.id)
      |> YouSpeakWeb.Plugs.SetUser.call(%{})

    {:ok, conn: conn}
  end

  test "GET /teacher/registration/new", %{conn: conn} do
    conn = get(conn, Routes.registration_path(conn, :new))

    assert html_response(conn, 200) =~ "Complete your registration"
  end
end
