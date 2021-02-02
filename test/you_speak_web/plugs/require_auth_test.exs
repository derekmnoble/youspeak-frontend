defmodule YouSpeakWeb.Plugs.RequireAuthTest do
  use YouSpeakWeb.ConnCase

  alias YouSpeak.Factory
  alias YouSpeakWeb.Plugs.RequireAuth

  def user_factory, do: Factory.insert!(:user)

  test "init/1 must return params" do
    assert nil == RequireAuth.init(%{})
  end

  test "call/2 with a user in assign struct must forward the conn request", %{conn: conn} do
    user = user_factory()

    conn =
      conn
      |> assign(:user, user)

    assert conn == RequireAuth.call(conn, %{})
  end

  test "call/2 without a user in a assign struct must redirect to root and halt request", %{
    conn: conn
  } do
    conn =
      conn
      |> assign(:user, nil)
      |> bypass_through(YouSpeakWeb.Router, :browser)
      |> get("/")
      |> RequireAuth.call(%{})

    assert get_flash(conn, :error) == "You must be logged in!"
    assert redirected_to(conn) == Routes.page_path(conn, :index)
    assert conn.halted()
  end
end
