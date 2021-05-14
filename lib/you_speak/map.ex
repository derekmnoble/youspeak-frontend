defmodule YouSpeak.Map do
  @moduledoc """
  Map module with helper functions.
  """

  @doc """
  Atomify map keys.

  ## Examples

      iex> YouSpeak.Map.keys_to_atoms("1")
      "1"

      iex> YouSpeak.Map.keys_to_atoms(92321)
      92321

      iex> YouSpeak.Map.keys_to_atoms(%{atom: "value"})
      %{atom: "value"}

      iex> YouSpeak.Map.keys_to_atoms(%{atom: "value", map: %{atom: "value"}})
      %{atom: "value", map: %{atom: "value"}}

      iex> YouSpeak.Map.keys_to_atoms(%{"string" => "value", map: %{atom: "value"}})
      %{string: "value", map: %{atom: "value"}}

      iex> YouSpeak.Map.keys_to_atoms(%{"string" => "value", "map" => %{"string" => "value"}})
      %{string: "value", map: %{string: "value"}}
  """
  def keys_to_atoms(%Plug.Upload{} = value), do: value
  def keys_to_atoms(%DateTime{} = value), do: value
  def keys_to_atoms(%NaiveDateTime{} = value), do: value
  def keys_to_atoms(%Date{} = value), do: value
  def keys_to_atoms(%Time{} = value), do: value

  def keys_to_atoms(string_key_map) when is_map(string_key_map) do
    for {key, val} <- string_key_map, into: %{} do
      if is_binary(key) do
        {String.to_atom(key), keys_to_atoms(val)}
      else
        {key, keys_to_atoms(val)}
      end
    end
  end

  def keys_to_atoms(value), do: value
end
