defmodule YouSpeakWeb.Groups.GroupController do
  use YouSpeakWeb, :controller
  alias YouSpeak.Groups.Schemas.Group
  alias YouSpeak.Groups.UseCases.{ListByTeacherID}

  plug YouSpeakWeb.Plugs.RequireAuth

  def index(conn, _params) do
    teacher = get_teacher_by_user_id(conn)
    groups = ListByTeacherID.call(teacher.id)

    render(conn, "index.html", groups: groups)
  end

  def new(conn, _params) do
    changeset = Group.changeset(%Group{}, %{})

    render(conn, "new.html", changeset: changeset)
  end

  # TODO: after create needs to redirect to list path
  # def create(conn, %{"group" => group_params}) do
  #   # {:error, changeset} ->
  #   #   render(conn, "new.html", changeset: changeset)
  #   group_params =
  #     group_params
  #     |> Map.merge(%{"teacher_id" => conn.assigns[:user].id})
  #
  #   IO.inspect(group_params)
  #
  #   case YouSpeak.Groups.create(group_params) do
  #     {:ok, _schema} ->
  #       conn
  #       |> put_flash(:info, "Group created!")
  #       |> redirect(to: Routes.page_path(conn, :index))
  #   end
  # end

  defp get_teacher_by_user_id(conn) do
    YouSpeak.Teachers.find_by_user_id(conn.assigns[:user].id)
  end
end
