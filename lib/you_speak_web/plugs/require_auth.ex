defmodule YouSpeakWeb.Plugs.RequireAuth do
  @moduledoc """
  RequireAuth plugs is used to check in every request if the user is being set, otherwise will
  deny access to the action
  """
  import Plug.Conn
  import Phoenix.Controller

  alias YouSpeakWeb.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in!")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end
end
