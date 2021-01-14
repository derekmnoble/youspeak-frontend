defmodule YouSpeak.Groups.Schemas.Group do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast(attributes, [:name, :description, :teacher_id, :activated_at, :inactivated_at])
    |> validate_required(@required_fields)
    |> validate_length(:name, max: 200)
    |> unique_constraint(:teacher)
    |> activate()
  end

  def changeset(%{id: id} = struct, attributes) when not is_nil(id) do
    struct
    |> cast(attributes, [:name, :description, :activated_at, :inactivated_at])
    |> validate_required(@required_fields)
    |> validate_length(:name, max: 200)
  end

  def active?(group), do: !is_nil(group.activated_at) && is_nil(group.inactivated_at)

  # def activate(%Team.Member{} = team_member) do
  #   team_member
  #   |> cast(%{active: true}, [:active])
  # end
  #
  # def inactivate(%Team.Member{} = team_member) do
  #   team_member
  #   |> cast(%{active: false}, [:active])
  # end

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
end
