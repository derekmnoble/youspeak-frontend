defmodule YouSpeak.Groups.UseCases.Create do
  @moduledoc """
  Creates a new group to teacher
  """

  import Ecto.Query, warn: false

  alias YouSpeak.Groups.Schemas.Group
  alias YouSpeak.Repo

  @typedoc """
  Params used to create new record
  """

  @type params :: %{
    name: String.t,
    description: String.t | nil,
    activated_at: nil,
    inactivated_at: nil,
    teacher_id: integer()
  }

  @typedoc """
  Params used to create new record
  """

  @type ok_group_or_error_changeset ::
          {:ok, YouSpeak.Teachers.Schemas.Group} | {:error, %Ecto.Changeset{}}

  @doc """
  Creates a new group to a given teacher

      iex> YouSpeak.Groups.UseCases.Create.call(%{name: "Test", teacher_id: 1})
      iex> %YouSpeak.Groups.Schemas.Group{}

      Params:

      - params: Map with attributes (name, teacher_id are required)
  """

  @spec call(params()) :: ok_group_or_error_changeset
  def call(params) do
    %Group{}
    |> Group.changeset(params)
    |> Repo.insert()
  end
end
