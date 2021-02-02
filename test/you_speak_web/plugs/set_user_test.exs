defmodule YouSpeakWeb.Plugs.SetUserTest do
  use YouSpeakWeb.ConnCase

  alias YouSpeak.Factory
  alias YouSpeakWeb.Plugs.SetUser

  def user_factory, do: Factory.insert!(:user)

  test "init/1 must return params" do
    assert nil == SetUser.init(%{})
  end

  test "call/2 with user in sessions must assigns user to conn assings struct", %{conn: conn} do
    user = user_factory()

    conn =
      conn
      |> Plug.Test.init_test_session(user_id: user.id)

    assert %{assigns: %{user: user}} = SetUser.call(conn, %{})

    assert user.id == user.id
  end

  test "call/2 without user in sessions must assigns NIL to conn assings struct", %{conn: conn} do
    conn =
      conn
      |> Plug.Test.init_test_session(user_id: nil)

    assert %{assigns: %{user: user}} = SetUser.call(conn, %{})

    assert user == nil
  end
end
