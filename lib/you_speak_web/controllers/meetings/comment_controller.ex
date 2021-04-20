defmodule YouSpeakWeb.Meetings.CommentController do
  use YouSpeakWeb, :controller

  alias YouSpeak.Meetings.Schemas.Comment
  alias YouSpeak.Meetings.UseCases.Comments.{Create}

  plug YouSpeakWeb.Plugs.RequireAuth

  def create(conn, %{"group_id" => group_slug, "meeting_id" => meeting_slug, "comment" => comment_params}) do
    if meeting = get_meeting(conn, meeting_slug, group_slug) do
      comment_params =
        comment_params
        |> Map.merge(%{"meeting_id" => meeting.id, "user_id" => conn.assigns[:user].id})

      case Create.call(comment_params) do
        {:ok, _schema} ->
          conn
          |> redirect(to: Routes.group_meeting_path(conn, :show, meeting.group, meeting))
      end
    end
  end

  defp get_meeting(conn, meeting_slug, group_slug) do
    YouSpeak.Meetings.get_by_slug!(%{slug: meeting_slug, group_id: get_group(group_slug).id})
  end

  defp get_group(slug) do
    YouSpeak.Meetings.get_by_slug!(slug)
  end
end
