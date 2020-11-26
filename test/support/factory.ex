defmodule YouSpeak.Factory do
  alias YouSpeak.Repo

  def build(:user) do
    %YouSpeak.Auth.Schemas.User{
      email: "test-#{System.unique_integer()}@dev.com.br",
      role: "teacher",
      provider: "google",
      token: "123"
    }
  end

  def build(factory_name, attributes) do
    factory_name
    |> build()
    |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name
    |> build(attributes)
    |> Repo.insert!()
  end
end
