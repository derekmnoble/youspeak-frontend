defmodule YouSpeakWeb.Meetings.MeetingController do
  use YouSpeakWeb, :controller

  alias YouSpeak.Meetings.Schemas.Meeting
  alias YouSpeak.Meetings.UseCases.ListByGroupSlug

  plug YouSpeakWeb.Plugs.RequireAuth

  @doc """
  List meetings by a given group

  ## Parameters
      - conn: The connection
      - params: The params are ignored
  """
  def index(conn, %{"group_id" => slug}) do
    if group = get_group_by_slug(conn, slug) do
      meetings = ListByGroupSlug.call(%{slug: group.slug, teacher_id: group.teacher_id})

      render(conn, "index.html", meetings: meetings, group: group)
    end
  rescue
    Ecto.NoResultsError ->
      render_not_found(conn)
  end

  @doc """
  Build a new changeset to create a new meeting

  ## Parameters
      - conn: The connection
      - params: The params are ignored
  """
  def new(conn, %{"group_id" => slug}) do
    if group = get_group_id_by_slug(conn, slug) do
      changeset = Meeting.changeset(%Meeting{}, %{})

      render(conn, "new.html", changeset: changeset, group: group)
    end
  rescue
    Ecto.NoResultsError ->
      render_not_found(conn)
  end

  @doc """
  Create a new group for the logged user/teacher

  ## Parameters
      - conn: The connection
      - params: The params will be data for create a new group
  """
  def create(conn, %{"group_id" => group_id, "meeting" => meeting_params}) do
    if get_group_id(conn, group_id) do
      meeting_params =
        meeting_params
        |> Map.merge(%{"group_id" => group_id})

      case YouSpeak.Meetings.create(meeting_params) do
        {:ok, _schema} ->
          conn
          |> put_flash(:info, "Meeting created!")
          |> redirect(to: Routes.group_path(conn, :index))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset, group: group_id)
      end
    end
  rescue
    Ecto.NoResultsError ->
      render_not_found(conn)
  end

  @doc """
  Gets a given meeting and open form to edit

  ## Parameters
      - conn: The connection
      - params: The params will be data to get a group
  """
  def edit(conn, %{"group_id" => group_slug, "id" => meeting_slug}) do
    group = get_group_by_slug(conn, group_slug)
    meeting = YouSpeak.Meetings.get_by_slug!(%{slug: meeting_slug, group_id: group.id})
    changeset = Meeting.changeset(meeting, %{})
    render(conn, "edit.html", changeset: changeset, group: group)
  rescue
    Ecto.NoResultsError ->
      render_not_found(conn)
  end

  # TODO: Dry!
  defp get_group_by_slug(conn, slug) do
    YouSpeak.Groups.get_by_slug!(%{slug: slug, teacher_id: conn.assigns[:teacher].id})
  end

  defp get_group_id_by_slug(conn, slug) do
    get_group_by_slug(conn, slug).id
  end

  defp get_group_id(conn, group_id) do
    YouSpeak.Groups.get!(%{group_id: group_id, teacher_id: conn.assigns[:teacher].id}).id
  end

  defp render_not_found(conn) do
    conn
    |> put_layout(false)
    |> put_status(:not_found)
    |> put_view(YouSpeakWeb.ErrorView)
    |> render(:"404")
  end
end
