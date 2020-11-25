defmodule YouSpeakWeb.Auth.AuthControllerTest do
  use YouSpeakWeb.ConnCase

  # alias Discuss.Repo
  # alias Discuss.Users.User
  # alias Discuss.Factory
  #
  # @ueberauth_auth %{
  #   credentials: %{
  #     token: "mytoken123",
  #   },
  #   info: %{
  #     email: "xunda@example.org",
  #     name: "xunda",
  #   }
  # }
  #
  # @invalid_ueberauth_auth %{
  #   credentials: %{
  #     token: "",
  #   },
  #   info: %{
  #     email: "xunda@example.org",
  #     name: "xunda",
  #   }
  # }
  #
  # def user_factory do
  #   Factory.insert(:user)
  # end
  #
  # test "redirects user to github auth", %{conn: conn} do
  #   conn = get(conn, auth_path(conn, :request, "github"))
  #
  #   assert redirected_to(conn, 302)
  # end
  #
  # test "GET /:github with success auth must create new user", %{conn: conn} do
  #   conn =
  #     conn
  #     |> assign(:ueberauth_auth, @ueberauth_auth)
  #     |> get(auth_path(conn, :callback, "github"))
  #
  #   users = Repo.all(User)
  #   assert Enum.count(users) == 1
  #
  #   assert get_flash(conn, :info) == "User xunda@example.org successful log in"
  #   assert redirected_to(conn) == topic_path(conn, :index)
  # end
  #
  # test "GET /:github with error auth must not create a new user", %{conn: conn} do
  #   conn =
  #     conn
  #     |> assign(:ueberauth_auth, @invalid_ueberauth_auth)
  #     |> get(auth_path(conn, :callback, "github"))
  #
  #   users = Repo.all(User)
  #   assert Enum.count(users) == 0
  #
  #   assert get_flash(conn, :error) == "Some shit happen, login failed!"
  #   assert redirected_to(conn) == topic_path(conn, :index)
  # end
  #
  # test "GET /signout must remove user from session", %{conn: conn} do
  #   user = user_factory()
  #
  #   conn = assign(conn, :user, user)
  #
  #   conn =
  #     conn
  #     |> get(auth_path(conn, :signout))
  #
  #   assert conn.assigns[:user] == nil
  #   assert get_flash(conn, :info) == "Successful sign out!"
  #   assert redirected_to(conn) == topic_path(conn, :index)
  # end
end
