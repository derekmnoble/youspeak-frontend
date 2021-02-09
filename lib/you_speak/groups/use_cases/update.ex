defmodule YouSpeak.Groups.UseCases.Update do
  @moduledoc """
  Updates a given group
  """

  import Ecto.Query, warn: false

  alias YouSpeak.Groups.Schemas.Group
  alias YouSpeak.Repo

  @typedoc """
  Params use to update a group
  """

  @type params :: %{
          name: String.t(),
          description: String.t() | nil,
          activated_at: nil,
          inactivated_at: nil,
          teacher_id: integer()
        }

  @typedoc """
  Retuned typespec for given function
  """
  @type ok_group_or_error_changeset ::
          {:ok, YouSpeak.Teachers.Schemas.Group} | {:error, %Ecto.Changeset{}}

  @doc """
  Creates a new group to a given teacher

      iex> YouSpeak.Groups.UseCases.Update.call(1, %{name: "Test"})
      iex> %YouSpeak.Groups.Schemas.Group{}

      Params:

      - group_id: id to be updated
      - params: Map with attributes (name, teacher_id are required)
  """
  @spec call(integer(), params()) :: ok_group_or_error_changeset
  def call(group_id, %{teacher_id: teacher_id} = params) do
    from(
      group in Group,
      where: group.id == ^group_id and group.teacher_id == ^teacher_id
    )
    |> Repo.one()
    |> case do
      nil ->
        {:error, "invalid id"}

      group ->
        group
        |> Group.changeset(params)
        |> Repo.update()
    end
  end
end
