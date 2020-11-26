defmodule YouSpeak.Auth.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  @email_validation_regex ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  @permitted_params [:email, :role, :provider, :token]
  @required_fields [:email, :role, :provider, :token]

  schema "users" do
    field :email, :string
    field :role, :string, default: "teacher"
    field :provider, :string
    field :token, :string

    timestamps()
  end

  def changeset(struct, attributes) do
    struct
    |> cast(attributes, @permitted_params)
    |> validate_required(@required_fields)
    |> validate_format(:email, @email_validation_regex)
    |> unique_constraint(:email)
  end
end
#
# defmodule YouSpeak.Users.Schemas.User do
#   use Ecto.Schema
#   use Pow.Ecto.Schema
#   import Ecto.Changeset
#
#   @email_validation_regex ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
#   @permitted_params [:name, :email, :role]
#
#   schema "users" do
#     pow_user_fields()
#
#     field :name, :string
#     field :role, :string, default: "teacher"
#     field :namespace, :string
#
#     timestamps()
#   end
#
#   @doc false
#   def changeset(_user, attrs \\ %{})
#
#   @doc false
#   def changeset(%{role: role} = user, attrs) when role == "teacher" do
#     user
#     |> pow_password_changeset(attrs)
#     |> cast(attrs, @permitted_params ++ [:namespace])
#     |> validate_required(:namespace)
#     |> validate_length(:namespace, max: 120)
#     |> slugify_namespace()
#     |> unique_constraint(:namespace)
#     |> validate()
#   end
#
#   @doc false
#   def changeset(user, attrs) do
#     user
#     |> pow_password_changeset(attrs)
#     |> cast(attrs, @permitted_params)
#     |> validate()
#   end
#
#   defp validate(user) do
#     user
#     |> validate_required(@permitted_params)
#     |> validate_length(:name, max: 120)
#     |> validate_format(:email, @email_validation_regex)
#     |> unique_constraint(:email, name: :users_email_index)
#     |> validate_inclusion(:role, ~w(student admin teacher))
#   end
#
#   defp slugify_namespace(%{changes: %{namespace: namespace} = changes} = user_changeset)
#        when map_size(changes) > 0
#        when not is_nil(namespace)
#        when namespace != "" do
#     slugified_namespace =
#       namespace
#       |> String.downcase()
#       |> String.replace(~r/[^a-z0-9\s-]/, "")
#       |> String.replace(~r/(\s|-)+/, "-")
#
#     put_change(user_changeset, :namespace, slugified_namespace)
#   end
#
#   defp slugify_namespace(changeset), do: changeset
# end
