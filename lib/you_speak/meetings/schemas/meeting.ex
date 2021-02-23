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
    field :slug, :string

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
    |> slugify_name()
    |> unique_constraint(:slug)
    |> unique_constraint(:group)
  end

  # TODO: Needs to apply DRY
  defp slugify_name(%{changes: %{name: name} = changes} = meeting_changeset)
       when map_size(changes) > 0
       when not is_nil(name)
       when name != "" do
    slugified_name =
      name
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9\s-]/, "")
      |> String.replace(~r/(\s|-)+/, "-")

    put_change(meeting_changeset, :slug, slugified_name)
  end

  defp slugify_name(changeset), do: changeset
end

defimpl Phoenix.Param, for: YouSpeak.Meetings.Schemas.Meeting do
  def to_param(%{slug: slug}), do: "#{slug}"
end
