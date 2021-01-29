defmodule YouSpeakWeb.Groups.GroupController do
  use YouSpeakWeb, :controller
  alias YouSpeak.Groups.Schemas.Group

  plug YouSpeakWeb.Plugs.RequireAuth

  def new(conn, _params) do
    changeset = Group.changeset(%Group{}, %{})

    render(conn, "new.html", changeset: changeset)
  end
end
