defmodule YouSpeakWeb.Auth.AuthController do
  use YouSpeakWeb, :controller
  plug Ueberauth

  def callback(conn, params) do
    text(conn, "ok")
  end
end
