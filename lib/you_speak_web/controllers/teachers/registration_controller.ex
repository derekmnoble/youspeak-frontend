defmodule YouSpeakWeb.Teachers.RegistrationController do
  use YouSpeakWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end
end
