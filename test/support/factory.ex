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

  def build(:teacher) do
    %YouSpeak.Teachers.Schemas.Teacher{
      name: "name-#{System.unique_integer()}",
      namespace: "namespace-#{System.unique_integer()}",
      description: "",
      url: "",
      user_id: __MODULE__.build(:user).id
    }
  end

  def build(:group) do
    %YouSpeak.Groups.Schemas.Group{
      name: "name-#{System.unique_integer()}",
      description: "description #{System.unique_integer()}",
      activated_at: ~N[2020-12-01 12:00:00],
      inactivated_at: nil,
      teacher_id: __MODULE__.build(:teacher).id
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
