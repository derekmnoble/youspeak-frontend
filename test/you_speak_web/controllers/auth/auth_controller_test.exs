defmodule YouSpeakWeb.Auth.AuthControllerTest do
  use YouSpeakWeb.ConnCase

  alias YouSpeak.Repo
  alias YouSpeak.Auth.Schemas.User
  alias YouSpeak.Factory

  import Ecto.Query, warn: false

  @ueberauth_auth %{
    credentials: %{
      token: "mytoken123",
    },
    info: %{
      email: "xunda@example.org",
      name: "xunda",
    },
    provider: :google
  }

  @invalid_ueberauth_auth %{
    credentials: %{
      token: "",
    },
    info: %{
      email: "xunda@example.org",
      name: "xunda",
    },
    provider: :""
  }

  def user_factory(attributes \\ %{}), do: Factory.insert!(:user, attributes)

  test "redirects user to google auth", %{conn: conn} do
    conn = get(conn, Routes.auth_path(conn, :request, "google"))

    assert redirected_to(conn, 302)
  end

  test "GET /:google with success auth must create new user", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @ueberauth_auth)
      |> get(Routes.auth_path(conn, :callback, "google"))

    assert Repo.one(from u in User, select: count(u.id)) == 1

    assert get_flash(conn, :info) == "User xunda@example.org successful log in"
    assert redirected_to(conn) == Routes.registration_path(conn, :new)
  end

  test "GET /:google with error auth must not create a new user", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @invalid_ueberauth_auth)
      |> get(Routes.auth_path(conn, :callback, "google"))

    assert Repo.one(from u in User, select: count(u.id)) == 0

    assert get_flash(conn, :error) == "Some problem happen, login failed!"
    assert redirected_to(conn) == Routes.page_path(conn, :index)
  end

  test "GET /signout must remove user from session", %{conn: conn} do
    user = user_factory()
    conn = assign(conn, :user, user)

    conn =
      conn
      |> get(Routes.auth_path(conn, :signout))

    assert is_nil(conn.assigns[:user])
    assert get_flash(conn, :info) == "Successful sign out!"
    assert redirected_to(conn) == Routes.page_path(conn, :index)
  end
end
