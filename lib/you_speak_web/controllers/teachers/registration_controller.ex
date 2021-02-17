defmodule YouSpeakWeb.Teachers.RegistrationController do
  use YouSpeakWeb, :controller
  alias YouSpeak.Teachers.Schemas.Teacher

  plug YouSpeakWeb.Plugs.RequireAuth when action in [:new]
  plug :redirect_to_page_path_if_teacher_already_exists when action in [:new]

  @doc """
  Build a new changeset to create a new teacher

  ## Parameters
      - conn: The connection
      - params: The params are ignored
  """
  def new(conn, _params) do
    changeset = Teacher.changeset(%Teacher{}, %{user_id: conn.assigns[:user].id})

    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  Create a new teacher

  ## Parameters
      - conn: The connection
      - params: The params will be data for create a new teacher
  """
  def create(conn, %{"teacher" => teacher_params}) do
    teacher_params =
      teacher_params
      |> Map.merge(%{"user_id" => conn.assigns[:user].id})

    case YouSpeak.Teachers.registration(teacher_params) do
      {:ok, _schema} ->
        conn
        |> put_flash(:info, "Registration completed!")
        |> redirect(to: Routes.group_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp redirect_to_page_path_if_teacher_already_exists(conn, _params) do
    if YouSpeak.Teachers.find_by_user_id(conn.assigns[:user].id) do
      conn
      |> redirect(to: Routes.group_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
