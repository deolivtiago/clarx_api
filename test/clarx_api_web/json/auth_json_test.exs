defmodule ClarxApiWeb.Json.AuthJSONTest do
  use ClarxApiWeb.ConnCase, async: true

  import ClarxApi.Factories.UserFactory

  alias ClarxApiWeb.Auth
  alias ClarxApiWeb.AuthJSON

  describe "show/1 returns success" do
    setup [:build_user, :build_auth]

    test "with auth data", %{user: user, token: token} do
      assert %{data: auth_data} = AuthJSON.show(%{auth: %{user: user, token: token}})

      assert auth_data.user.id == user.id
      assert auth_data.user.name == user.name
      assert auth_data.user.email == user.email
      assert auth_data.token == token
    end
  end

  defp build_user(_) do
    :user
    |> build()
    |> then(&{:ok, user: &1})
  end

  defp build_auth(%{user: user}) do
    Auth.authenticate(user, user.password)
  end
end
