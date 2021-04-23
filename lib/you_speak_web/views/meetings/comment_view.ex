defmodule YouSpeakWeb.Meetings.CommentView do
  @moduledoc false
  use YouSpeakWeb, :view

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, __MODULE__, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id, url: comment.url, meeting_id: comment.meeting_id, user_id: comment.user_id}
  end
end
