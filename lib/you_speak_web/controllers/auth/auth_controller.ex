defmodule YouSpeakWeb.Auth.AuthController do
  use YouSpeakWeb, :controller
  plug Ueberauth

  def callback(conn, params) do
    IO.inspect(conn.assigns)
    IO.inspect(params)
  end
end
