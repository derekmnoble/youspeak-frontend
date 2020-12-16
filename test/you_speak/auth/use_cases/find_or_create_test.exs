defmodule YouSpeak.Auth.UseCases.FindOrCreateTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Auth.Schemas.User
  alias YouSpeak.Auth.UseCases.FindOrCreate

  doctest FindOrCreate

  def user_factory(attributes \\ %{}), do: Factory.insert!(:user, attributes)

  test "call/1 returns error when params is empty" do
    assert {:error, "params is empty"} = FindOrCreate.call(%{})
  end

  test "call/1 must create a new user record when does not find" do
    params = %{
      email: "test-#{System.unique_integer()}@dev.com.br",
      provider: "google",
      token: "token123"
    }

    {:ok, user} = FindOrCreate.call(params)

    assert user.email == params.email
    assert user.token == params.token
    assert user.provider == params.provider
  end

  test "call/1 with new and invalid email data must raise error" do
    params = %{
      email: "",
      provider: "google",
      token: "token123"
    }

    {:error, result} = FindOrCreate.call(params)

    refute result.valid?
    assert "can't be blank" in errors_on(result).email
  end

  test "call/1 with new and invalid provider data must raise error" do
    params = %{
      email: "test-#{System.unique_integer()}@dev.com.br",
      provider: "",
      token: "token123"
    }

    {:error, result} = FindOrCreate.call(params)

    refute result.valid?
    assert "can't be blank" in errors_on(result).provider
  end

  test "call/1 with new and invalid data token must raise error" do
    params = %{
      email: "test-#{System.unique_integer()}@dev.com.br",
      provider: "google",
      token: ""
    }

    {:error, result} = FindOrCreate.call(params)

    refute result.valid?
    assert "can't be blank" in errors_on(result).token
  end

  test "call/1 with an already created user must return this user" do
    params = %{
      email: "test-#{System.unique_integer()}@dev.com.br",
      provider: "google",
      token: "token123"
    }

    FindOrCreate.call(params)

    records_total = Repo.one(from u in User, select: count(u.id))
    assert records_total == 1

    {:ok, user} = FindOrCreate.call(params)

    records_total = Repo.one(from u in User, select: count(u.id))
    assert records_total == 1
    assert user.email == params.email
  end
end
