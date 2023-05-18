defmodule ClarxApiWeb.AuthTest do
  use ClarxApi.DataCase

  import ClarxApi.Factories.UserFactory

  alias ClarxApiWeb.Auth

  setup do
    :user
    |> insert()
    |> then(&{:ok, user: &1})
  end

  describe "authenticate/2 returns" do
    test "ok when password is valid", %{user: user} do
      assert {:ok, %{user: ^user, token: token}} = Auth.authenticate(user, user.password)

      assert %{type: "bearer", access: _access_token, refresh: _refresh_token} = token
    end

    test "error when password is invalid", %{user: user} do
      assert {:error, %{valid?: false} = changeset} = Auth.authenticate(user, "invalid_password")
      errors = errors_on(changeset)

      assert Enum.member?(errors.email, "invalid credentials")
      assert Enum.member?(errors.password, "invalid credentials")
    end
  end
end
