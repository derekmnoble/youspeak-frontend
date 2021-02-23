defmodule YouSpeak.Groups.Schemas.Group do
  @moduledoc """
  Group schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :description]

  schema "groups" do
    field :name, :string
    field :description, :string
    field :activated_at, :naive_datetime
    field :inactivated_at, :naive_datetime
    field :slug, :string

    belongs_to :teacher, YouSpeak.Teachers.Schemas.Teacher

    timestamps()
  end

  def changeset(%{id: id} = struct, attributes) when not is_nil(id) do
    struct
    |> cast(attributes, [:name, :description, :activated_at, :inactivated_at, :slug])
    |> validate_required(@required_fields)
    |> validate_length(:name, max: 200)
    |> slugify_name()
  end

  def changeset(%{id: id} = struct, attributes) when is_nil(id) do
    struct
    |> cast(attributes, [:name, :description, :teacher_id, :activated_at, :inactivated_at])
    |> validate_required(@required_fields)
    |> validate_length(:name, max: 200)
    |> slugify_name()
    |> unique_constraint(:slug)
    |> unique_constraint(:teacher)
    |> activate()
  end

  def active?(group), do: !is_nil(group.activated_at) && is_nil(group.inactivated_at)

  def activate(struct) do
    activated_at =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    struct
    |> cast(%{activated_at: activated_at, inactivated_at: nil}, [:activated_at, :inactivated_at])
  end

  def inactivate(struct) do
    inactivated_at =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    struct
    |> cast(%{activated_at: nil, inactivated_at: inactivated_at}, [:activated_at, :inactivated_at])
  end

  # TODO: Needs to apply DRY
  defp slugify_name(%{changes: %{name: name} = changes} = group_changeset)
       when map_size(changes) > 0
       when not is_nil(name)
       when name != "" do
    slugified_name =
      name
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9\s-]/, "")
      |> String.replace(~r/(\s|-)+/, "-")

    put_change(group_changeset, :slug, slugified_name)
  end

  defp slugify_name(changeset), do: changeset
end

defimpl Phoenix.Param, for: YouSpeak.Groups.Schemas.Group do
  def to_param(%{slug: slug}), do: "#{slug}"
end
