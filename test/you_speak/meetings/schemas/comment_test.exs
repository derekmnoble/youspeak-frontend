defmodule YouSpeak.Meetings.Schemas.CommentTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Meetings.Schemas.Comment

  def comment_factory(attributes \\ %{}), do: Factory.build(:comment, attributes)

  test "return valid true when data is valid" do
    changeset =
      comment_factory()
      |> Comment.changeset(%{})

    assert changeset.valid?
  end
end
