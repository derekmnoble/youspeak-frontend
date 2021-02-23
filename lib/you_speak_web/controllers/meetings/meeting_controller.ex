defmodule YouSpeakWeb.Meetings.MeetingController do
  use YouSpeakWeb, :controller

  alias YouSpeak.Meetings.Schemas.Meeting

  plug YouSpeakWeb.Plugs.RequireAuth

  @doc """
  Build a new changeset to create a new meeting

  ## Parameters
      - conn: The connection
      - params: The params are ignored
  """
  def new(conn, _params) do
    changeset = Meeting.changeset(%Meeting{}, %{})

    render(conn, "new.html", changeset: changeset)
  end
end
