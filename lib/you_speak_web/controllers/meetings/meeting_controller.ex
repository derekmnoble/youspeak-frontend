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
  def new(conn, %{"group_id" => group_id}) do
    changeset = Meeting.changeset(%Meeting{}, %{})

    render(conn, "new.html", changeset: changeset, group_id: group_id)
  end

  @doc """
  Create a new group for the logged user/teacher

  ## Parameters
      - conn: The connection
      - params: The params will be data for create a new group
  """
  def create(conn, %{"group_id" => group_id, "meeting" => meeting_params}) do
    meeting_params =
      meeting_params
      |> Map.merge(%{"group_id" => group_id})

    case YouSpeak.Meetings.create(meeting_params) do
      {:ok, _schema} ->
        conn
        |> put_flash(:info, "Meeting created!")
        |> redirect(to: Routes.group_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # defp get_group_id(conn) do
  #   YouSpeak.Teachers.find_by_user_id(conn.assigns[:user].id)
  # end

  # defp render_not_found(conn) do
  #   conn
  #   |> put_layout(false)
  #   |> put_status(:not_found)
  #   |> put_view(YouSpeakWeb.ErrorView)
  #   |> render(:"404")
  # end
end
