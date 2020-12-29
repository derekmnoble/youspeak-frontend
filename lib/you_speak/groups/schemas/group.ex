defmodule YouSpeak.Groups.Schemas.Group do
  use Ecto.Schema
  import Ecto.Changeset

  @permitted_params [:name, :description, :teacher_id]
  @required_fields [:name, :description]

  schema "groups" do
    field :name, :string
    field :description, :string
    field :activated_at, :naive_datetime
    field :inactivated_at, :naive_datetime

    belongs_to :teacher, YouSpeak.Teachers.Schemas.Teacher

    timestamps()
  end

  def changeset(struct, attributes) do
    struct
    |> cast(attributes, @permitted_params)
    |> validate_required(@required_fields)
    |> validate_length(:name, max: 200)
    |> unique_constraint(:teacher)
  end

  def active?(group), do: !is_nil(group.activated_at) && is_nil(group.inactivated_at)
end
