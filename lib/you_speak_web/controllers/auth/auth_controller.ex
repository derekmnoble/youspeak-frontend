defmodule YouSpeakWeb.Auth.AuthController do
  use YouSpeakWeb, :controller
  plug Ueberauth

  @doc """
  Callback for a given OAuth resource

  ## Parameters
      - conn: The connection
      - params: The params provided by the callback
  """
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: Atom.to_string(auth.provider)
    }

    case YouSpeak.Auth.find_or_create(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User #{user.email} successful log in")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.registration_path(conn, :new))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Some problem happen, login failed!")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  @doc """
  Sign out the user

  ## Parameters
      - conn: The connection
      - params: The params are ignored
  """
  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Successful sign out!")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
