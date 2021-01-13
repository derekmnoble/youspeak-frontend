defmodule YouSpeak.Groups.UseCases.Get do
  @moduledoc """
  Gets a group by ID
  """

  import Ecto.Query, warn: false

  alias YouSpeak.Groups.Schemas.Group
  alias YouSpeak.Repo

  @type group_or_nil :: YouSpeak.Teachers.Schemas.Group | nil

  @doc """
  Gets a given group by its ID

      iex> YouSpeak.Groups.UseCases.Get.call(1)
      iex> %YouSpeak.Groups.Schemas.Group{}

      Params:

      - group_id
  """

  @spec call(integer()) :: group_or_nil
  def call(group_id) do
    Repo.get(Group, group_id)
  end
end
