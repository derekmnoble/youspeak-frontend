defmodule YouSpeak.Groups.UseCases.Delete do
  @moduledoc """
  Delete a group
  """

  import Ecto.Query, warn: false

  alias YouSpeak.Groups.Schemas.Group
  alias YouSpeak.Repo

  @type group :: Ecto.Schema.t()
  @type ok_group_or_error_changeset :: {:ok, Group} | {:error, %Ecto.Changeset{}}

  @doc """
  Delete a given group

      iex> YouSpeak.Groups.UseCases.Group.call(%Group{})
      iex> {:ok, %YouSpeak.Groups.Schemas.Group{}}

      Params:

      - group struct
  """
  @spec call(group(), integer()) :: ok_group_or_error_changeset
  def call(group, teacher_id) do
    from(
      g in Group,
      where: g.id == ^group.id and g.teacher_id == ^teacher_id
    )
    |> Repo.one()
    |> case do
      nil ->
        {:error, %Ecto.Changeset{errors: [teacher_id: "invalid teacher_id"]}}

      group ->
        Repo.delete(group)
    end
  end
end
