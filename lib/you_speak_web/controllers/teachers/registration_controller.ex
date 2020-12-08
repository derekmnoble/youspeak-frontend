defmodule YouSpeakWeb.Teachers.RegistrationController do
  use YouSpeakWeb, :controller
  alias YouSpeak.Teachers.Schemas.Teacher

  plug YouSpeakWeb.Plugs.RequireAuth when action in [:new]

  def new(conn, _params) do
    changeset = Teacher.changeset(%Teacher{}, %{user_id: conn.assigns[:user].id})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"teacher" => teacher_params}) do
    teacher_params =
      teacher_params
      |> Map.merge(%{"user_id" => conn.assigns[:user].id})

    # Move the call to a bounded context
    case YouSpeak.Teachers.UseCases.Registration.call(teacher_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Registration completed!")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
