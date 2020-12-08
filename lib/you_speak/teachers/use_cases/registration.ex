defmodule YouSpeak.Teachers.UseCases.Registration do
  @moduledoc """
  Registration is the use case responsible to enable an already logged teacher to complete
  the current registrarion by adding more information.
  """

  alias YouSpeak.Repo
  alias YouSpeak.Teachers.Schemas.Teacher

  def call(params) when map_size(params) == 0, do: {:error, "error"}
  def call(params) do
    %Teacher{}
    |> Teacher.changeset(params)
    |> Repo.insert()
  end
end
