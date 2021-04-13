defmodule YouSpeak.Comments do
  @moduledoc """
  Comments bounded context contains all use cases available to the comments context.
  """

  alias YouSpeak.Meetings.UseCases.Comments.{Create}

  @spec create(Create.params()) :: Create.ok_comment_or_error_changeset()
  def create(params), do: Create.call(params)
end
