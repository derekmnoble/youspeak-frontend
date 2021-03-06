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

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  @doc """
  Gets a given group and show details

  ## Parameters
      - conn: The connection
      - params: The params will be data to get a group
  """
  def show(conn, %{"id" => id}) do
    group = YouSpeak.Groups.get_by_slug!(%{slug: id, teacher_id: get_teacher_by_user_id(conn).id})
    render(conn, "show.html", group: group)
  rescue
    Ecto.NoResultsError ->
      render_not_found(conn)
  end

  @doc """
  Gets a given group and open form to edit

  ## Parameters
      - conn: The connection
      - params: The params will be data to get a group
  """
  def edit(conn, %{"id" => id}) do
    group = YouSpeak.Groups.get_by_slug!(%{slug: id, teacher_id: get_teacher_by_user_id(conn).id})
    changeset = Group.changeset(group, %{})
    render(conn, "edit.html", changeset: changeset, group: group)
  rescue
    Ecto.NoResultsError ->
      render_not_found(conn)
  end

  @doc """
  Updates a given group

  ## Parameters

    - conn: The connection
    - params: The params to update a group
  """
  def update(conn, %{"id" => id, "group" => group_params}) do
    group = YouSpeak.Groups.get!(%{group_id: id, teacher_id: get_teacher_by_user_id(conn).id})

    group_params =
      group_params
      |> Map.merge(%{"teacher_id" => get_teacher_by_user_id(conn).id})
      |> YouSpeak.Map.keys_to_atoms()

    case YouSpeak.Groups.update(id, group_params) do
      {:ok, _schema} ->
        conn
        |> put_flash(:info, "Group updated")
        |> redirect(to: Routes.group_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset, group: group)
    end
  rescue
    Ecto.NoResultsError ->
      render_not_found(conn)
  end

  defp get_teacher_by_user_id(conn) do
    YouSpeak.Teachers.find_by_user_id(conn.assigns[:user].id)
  end

  defp render_not_found(conn) do
    conn
    |> put_layout(false)
    |> put_status(:not_found)
    |> put_view(YouSpeakWeb.ErrorView)
    |> render(:"404")
  end
end
