defmodule YouSpeakWeb.Teachers.RegistrationController do
  use YouSpeakWeb, :controller
  alias YouSpeak.Teachers.Schemas.Teacher

  plug YouSpeakWeb.Plugs.RequireAuth when action in [:new]

  def new(conn, _params) do
    changeset = Teacher.changeset(%Teacher{}, %{user_id: conn.assigns[:user].id})

    render(conn, "new.html", changeset: changeset)
  end
end
