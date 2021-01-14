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

  @spec call(group()) :: ok_group_or_error_changeset
  def call(group) do
    Repo.delete(group)
  end
end
