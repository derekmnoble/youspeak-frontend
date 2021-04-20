defmodule YouSpeak.Groups.UseCases.GetBySlug do
  @moduledoc """
  Gets a group by slug
  """

  import Ecto.Query, warn: false

  alias YouSpeak.Groups.Schemas.Group
  alias YouSpeak.Repo

  @type params() :: %{
          slug: String.t(),
          teacher_id: integer()
        }

  @type group_or_exception :: YouSpeak.Teachers.Schemas.Group | Ecto.NoResultsError

  @doc """
  Gets a given group by its slug and teacher_id

      iex> YouSpeak.Groups.UseCases.GetBySlug.call(%{slug: "group-slug", teacher_id: 22})
      iex> %YouSpeak.Groups.Schemas.Group{}

      Params:

      - params: %{slug: "group-slug", teacher_id: 2}
  """
  @spec call(params()) :: group_or_exception
  def call(%{slug: slug, teacher_id: teacher_id}) do
    from(
      group in Group,
      where: group.slug == ^slug and group.teacher_id == ^teacher_id
    )
    |> Repo.one!()
  end

  @doc """
  Gets a given group by its slug

      iex> YouSpeak.Groups.UseCases.GetBySlug.call(%{slug: "group-slug"})
      iex> %YouSpeak.Groups.Schemas.Group{}

      Params:

      - params: %{slug: "group-slug"}
  """
  @spec call(String.t()) :: group_or_exception
  def call(slug) do
    from(
      group in Group,
      where: group.slug == ^slug
    )
    |> Repo.one!()
  end
end
