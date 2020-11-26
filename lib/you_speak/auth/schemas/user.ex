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
    |> validate_inclusion(:role, ~w(student admin teacher))
  end
end
