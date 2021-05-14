defmodule YouSpeakWeb.Meetings.CommentController do
  use YouSpeakWeb, :controller

  alias YouSpeak.Meetings.UseCases.Comments.{Create}

  # plug YouSpeakWeb.Plugs.RequireAuth

  def create(conn, %{
        "group_id" => group_slug,
        "meeting_id" => meeting_slug,
        "comment" => comment_params
      }) do
    if meeting = get_meeting(meeting_slug, group_slug) do
      comment_params =
        comment_params
        |> Map.merge(%{"meeting_id" => meeting.id, "user_id" => conn.assigns[:user].id})

      case Create.call(comment_params) do
        {:ok, comment} ->
          conn
          |> put_status(:created)
          |> render("show.json", comment: comment)
      end
    end
  end

  def upload(conn, %{"comment" => comment}) do
    IO.inspect(comment, label: :comment)
    conn
    |> put_status(:ok)
    |> render("show.json", %{})
  end

  defp get_meeting(meeting_slug, group_slug) do
    YouSpeak.Meetings.get_by_slug!(%{slug: meeting_slug, group_id: get_group(group_slug).id})
  end

  defp get_group(slug) do
    YouSpeak.Groups.get_by_slug!(slug)
  end
end
