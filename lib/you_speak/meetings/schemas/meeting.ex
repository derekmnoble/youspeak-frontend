defmodule YouSpeak.Meetings.Schemas.Meeting do
  @moduledoc """
  Meeting schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :description, :video_url]

  schema "meetings" do
    field :name, :string
    field :description, :string
    field :video_url, :string

    belongs_to :group, YouSpeak.Groups.Schemas.Group

    timestamps()
  end

  # def changeset(%{id: id} = struct, attributes) when not is_nil(id) do
  #   struct
  #   |> cast(attributes, [:name, :description, :activated_at, :inactivated_at])
  #   |> validate_required(@required_fields)
  #   |> validate_length(:name, max: 200)
  # end

  def changeset(%{id: id} = struct, attributes) when is_nil(id) do
    struct
    |> cast(attributes, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, max: 200)
    |> unique_constraint(:group)
  end
end
