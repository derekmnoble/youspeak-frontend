defmodule YouSpeak.Teachers.Schemas.Teacher do
  use Ecto.Schema
  import Ecto.Changeset

  @permitted_params [:name, :namespace, :description, :url]
  @required_fields [:name, :namespace]

  schema "teachers" do
    field :name, :string
    field :namespace, :string
    field :description, :string
    field :url

    belongs_to :user, YouSpeak.Auth.Schemas.User

    timestamps()
  end

  def changeset(struct, attributes) do
    struct
    |> cast(attributes, @permitted_params)
    |> validate_required(@required_fields)
    |> validate_length(:name, max: 200)
    |> validate_length(:namespace, max: 200)
    |> slugify_namespace()
    |> unique_constraint(:namespace)
  end

  defp slugify_namespace(%{changes: %{namespace: namespace} = changes} = user_changeset)
       when map_size(changes) > 0
       when not is_nil(namespace)
       when namespace != "" do
    slugified_namespace =
      namespace
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9\s-]/, "")
      |> String.replace(~r/(\s|-)+/, "-")

    put_change(user_changeset, :namespace, slugified_namespace)
  end

  defp slugify_namespace(changeset), do: changeset
end
