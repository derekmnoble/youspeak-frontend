defmodule YouSpeak.Auth.UseCases.FindOrCreate do
  @moduledoc """
  Responsible to handle new sign in using google oauth, it will handle
  and create a new user in the first access or just return a user that already exists.
  """

  import Ecto.Query, warn: false

  alias YouSpeak.Repo
  alias YouSpeak.Auth.Schemas.User

  @typedoc """
  Params used to fetch record
  """
  @type params() :: %{
          email: String.t()
        }

  @type ok_user_or_error_string :: {:ok, %YouSpeak.Auth.Schemas.User{}} | {:error, String.t()}

  @doc """
  Returns the user based on the email or create a new one.

  ## Examples

      iex> YouSpeak.Auth.UseCases.FindOrCreate.call(%{})
      iex> {:error, "params is empty"}
      iex> YouSpeak.Auth.UseCases.FindOrCreate.call(%{email: "invalid@example.org"})
      iex> %YouSpeak.Auth.Schemas.User{}
  """
  @spec call(params()) :: ok_user_or_error_string
  def call(params) when map_size(params) == 0, do: {:error, "params is empty"}

  def call(params) do
    result =
      User
      |> where(email: ^params.email)
      |> Repo.one()

    case result do
      nil ->
        %User{}
        |> User.changeset(params)
        |> Repo.insert()

      user ->
        {:ok, user}
    end
  end
end
