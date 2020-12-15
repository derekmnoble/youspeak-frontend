defmodule YouSpeakWeb.Teachers.RegistrationController do
  use YouSpeakWeb, :controller
  alias YouSpeak.Teachers.Schemas.Teacher

  plug YouSpeakWeb.Plugs.RequireAuth when action in [:new]
  plug :redirect_to_page_path_if_teacher_already_exists when action in [:new]

  def new(conn, _params) do
    changeset = Teacher.changeset(%Teacher{}, %{user_id: conn.assigns[:user].id})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"teacher" => teacher_params}) do
    teacher_params =
      teacher_params
      |> Map.merge(%{"user_id" => conn.assigns[:user].id})

    case YouSpeak.Teachers.registration(teacher_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Registration completed!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp redirect_to_page_path_if_teacher_already_exists(conn, _) do
    if YouSpeak.Repo.get_by(Teacher, user_id: conn.assigns[:user].id) do
      conn
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
