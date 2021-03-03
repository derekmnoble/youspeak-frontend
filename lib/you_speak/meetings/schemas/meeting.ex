defmodule YouSpeak.Meetings.Schemas.Meeting do
  @moduledoc """
  Meeting schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :video_url]

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
    |> cast(attributes, [:name, :description, :video_url, :group_id])
    |> validate_required(@required_fields)
    |> validate_length(:name, max: 200)
    |> slugify_name()
    |> validate_video_url()
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

  # Copy and past from: https://gist.github.com/atomkirk/74b39b5b09c7d0f21763dd55b877f998
  def validate_video_url(changeset) do
    validate_change(changeset, :video_url, fn _, video_url ->
      case URI.parse(video_url) do
        %URI{scheme: nil} ->
          "is missing a scheme (e.g. https)"

        %URI{host: nil} ->
          "is missing a host"

        %URI{host: host} ->
          case :inet.gethostbyname(Kernel.to_charlist(host)) do
            {:ok, _} -> nil
            {:error, _} -> "invalid host"
          end
      end
      |> case do
        error when is_binary(error) -> [{:video_url, Keyword.get([], :message, error)}]
        _ -> []
      end
    end)
  end

  defmodule Test do
    def get_video_id("http://youtu.be/" <> id), do: id
    def get_video_id("http://www.youtube.com/watch?v=" <> id), do: id
    def get_video_id("http://www.youtube.com/?v=" <> id), do: id
    def get_video_id("https://youtu.be/" <> id), do: id
    def get_video_id("https://www.youtube.com/watch?v=" <> id), do: id
    def get_video_id("https://www.youtube.com/?v=" <> id), do: id
  end
end

defimpl Phoenix.Param, for: YouSpeak.Meetings.Schemas.Meeting do
  def to_param(%{slug: slug}), do: "#{slug}"
end
