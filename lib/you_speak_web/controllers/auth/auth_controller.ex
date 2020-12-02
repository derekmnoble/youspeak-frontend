defmodule YouSpeakWeb.Auth.AuthController do
  use YouSpeakWeb, :controller
  plug Ueberauth

  alias YouSpeak.Auth.UseCases.FindOrCreate

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: Atom.to_string(auth.provider)
    }

    case FindOrCreate.call(user_params) do
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

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Successful sign out!")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
