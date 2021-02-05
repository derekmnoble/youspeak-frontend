defmodule YouSpeakWeb.Groups.GroupController do
  use YouSpeakWeb, :controller
  alias YouSpeak.Groups.Schemas.Group
  alias YouSpeak.Groups.UseCases.{ListByTeacherID}

  plug YouSpeakWeb.Plugs.RequireAuth

  @doc """
  List groups by a given teacher

  ## Parameters
      - conn: The connection
      - params: The params are ignored
  """
  def index(conn, _params) do
    teacher = get_teacher_by_user_id(conn)
    groups = ListByTeacherID.call(teacher.id)

    render(conn, "index.html", groups: groups)
  end

  @doc """
  Build a new changeset to create a new group

  ## Parameters
      - conn: The connection
      - params: The params are ignored
  """
  def new(conn, _params) do
    changeset = Group.changeset(%Group{}, %{})

    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  Create a new group for the logged user/teacher

  ## Parameters
      - conn: The connection
      - params: The params will be data for create a new group
  """
  def create(conn, %{"group" => group_params}) do
    group_params =
      group_params
      |> Map.merge(%{"teacher_id" => get_teacher_by_user_id(conn).id})

    case YouSpeak.Groups.create(group_params) do
      {:ok, _schema} ->
        conn
        |> put_flash(:info, "Group created!")
        |> redirect(to: Routes.group_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    group = YouSpeak.Groups.get(%{group_id: id, teacher_id: get_teacher_by_user_id(conn).id})

    render(conn, "show.html", group: group)
  end

  defp get_teacher_by_user_id(conn) do
    YouSpeak.Teachers.find_by_user_id(conn.assigns[:user].id)
  end
end
