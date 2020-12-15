defmodule YouSpeak.TeachersTest do
  use YouSpeak.DataCase

  alias YouSpeak.Teachers.UseCases.Registration

  test "registration/1 with valid data must calls UseCases.Registration and return {:ok, record}" do
    params = %{
      name: "Name",
      namespace: "Namespace",
      description: "",
      url: "http://pudim.com.br"
    }

    assert {:ok, _} = Registration.call(params)
  end

  test "registration/1 with invalid data must calls UseCases.Registration and return {:error, changeset}" do
    params = %{
      name: "Name",
      namespace: "",
      description: "",
      url: "http://pudim.com.br"
    }

    assert {:error, _} = Registration.call(params)
  end
end
