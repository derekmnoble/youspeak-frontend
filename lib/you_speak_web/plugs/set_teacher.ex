defmodule YouSpeakWeb.Plugs.SetTeacher do
  @moduledoc """
    Plug to set teacher_id on conn session
  """

  use Phoenix.Controller
  import Plug.Conn

  def init(_params) do
  end

  def call(conn, _params) do
    if is_nil(conn.assigns[:user]) do
      assign(conn, :teacher, nil)
    else
      teacher = YouSpeak.Teachers.find_by_user_id(conn.assigns[:user].id)
      assign(conn, :teacher, teacher)
    end
  end
end
