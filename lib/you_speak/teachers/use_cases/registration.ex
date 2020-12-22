defmodule YouSpeak.Teachers.UseCases.Registration do
  @moduledoc """
  Use case responsible to enable an already logged teacher to complete
  the current registration by adding more information.
  """

  alias YouSpeak.Repo
  alias YouSpeak.Teachers.Schemas.Teacher

  @typedoc """
  Params used to create new record
  """
  @type params() :: %{
    name: String.t(),
    namespace: String.t(),
    description: String.t(),
    url: String.t()
  }

  @doc """
  Inserts a new teacher in the database or raise an error

  ## Examples

      iex> YouSpeak.Teachers.UseCases.Registration.call(%{})
      iex> {:error, "error"}
      iex> YouSpeak.Teachers.UseCases.Registration.call(%{name: "Test", Namespace: "Test"})
      iex> %YouSpeak.Teachers.Schemas.Teacher{}
  """

  @spec call(params()) :: {:ok, YouSpeak.Teachers.Schemas.Teacher} | {:error, %Ecto.Changeset{}}
  def call(params) when map_size(params) == 0, do: {:error, "error"}
  def call(params) do
    %Teacher{}
    |> Teacher.changeset(params)
    |> Repo.insert()
  end
end
