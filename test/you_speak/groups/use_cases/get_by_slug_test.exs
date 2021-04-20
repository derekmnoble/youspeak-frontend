defmodule YouSpeak.Groups.UseCases.GetBySlugTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Groups.Schemas.Group
  alias YouSpeak.Groups.UseCases.GetBySlug

  # doctest YouSpeak.Groups.UseCases.GetBySlug

  def teacher_factory(attributes \\ %{}), do: Factory.insert!(:teacher, attributes)
  def group_factory(attributes \\ %{}), do: Factory.insert!(:group, attributes)

  test "call/1 with an existent group" do
    params = %{name: "My name", description: "description", teacher_id: teacher_factory().id}

    {:ok, group} =
      %Group{}
      |> Group.changeset(params)
      |> Repo.insert()

    params = %{slug: group.slug, teacher_id: group.teacher_id}
    result = GetBySlug.call(params)
    assert result.id == group.id

    result = GetBySlug.call(group.slug)
    assert result.id == group.id
  end

  test "call/1 with invalid group returns nil" do
    assert_raise Ecto.NoResultsError, fn ->
      GetBySlug.call(%{slug: "invalid slug", teacher_id: teacher_factory().id})
    end

    assert_raise Ecto.NoResultsError, fn ->
      GetBySlug.call("invalid-slug")
    end
  end
end
