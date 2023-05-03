defmodule ClarxApiWeb.UserJSONTest do
  use ClarxApiWeb.ConnCase, async: true

  import ClarxApi.Factories.UserFactory

  alias ClarxApiWeb.UserJSON

  describe "render/3 returns success" do
    setup [:build_user]

    test "with a list of users", %{user: user} do
      assert %{data: [user_data]} = UserJSON.index(%{users: [user]})

      assert user_data.id == user.id
      assert user_data.name == user.name
      assert user_data.email == user.email
    end

    test "with a single user", %{user: user} do
      assert %{data: user_data} = UserJSON.show(%{user: user})

      assert user_data.id == user.id
      assert user_data.name == user.name
      assert user_data.email == user.email
    end
  end

  defp build_user(_) do
    :user
    |> build()
    |> Map.put(:password, nil)
    |> then(&{:ok, user: &1})
  end
end
