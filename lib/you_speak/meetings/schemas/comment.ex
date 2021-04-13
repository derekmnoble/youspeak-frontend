defmodule YouSpeak.Meetings.Schemas.Comment do
  @moduledoc """
  Comment schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:url]

  schema "comments" do
    field :url, :string

    belongs_to :meeting, YouSpeak.Meetings.Schemas.Meeting
    belongs_to :user, YouSpeak.Auth.Schemas.User

    timestamps()
  end

  def changeset(struct, attributes) do
    struct
    |> cast(attributes, [:url, :user_id, :meeting_id])
    |> validate_required(@required_fields)
  end
end
