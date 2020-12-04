defmodule YouSpeakWeb.Teachers.RegistrationController do
  use YouSpeakWeb, :controller

  plug YouSpeakWeb.Plugs.RequireAuth when action in [:new]

  def new(conn, _params) do
    render(conn, "new.html")
  end
end
