defmodule YouSpeakWeb.Plugs.SetUser do
  @moduledoc """
    Plug to set user_id on conn session
  """

  use Phoenix.Controller
  import Plug.Conn

  alias YouSpeak.Repo
  alias YouSpeak.Auth.Schemas.User

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user)

      true ->
        assign(conn, :user, nil)
    end
  end
end
