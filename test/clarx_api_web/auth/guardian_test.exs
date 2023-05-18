defmodule ClarxApiWeb.Auth.GuardianTest do
  use ClarxApi.DataCase

  import ClarxApi.Factories.UserFactory

  alias ClarxApiWeb.Auth.Guardian

  setup do
    :user
    |> insert()
    |> Map.put(:password, nil)
    |> then(&{:ok, user: &1})
  end

  describe "subject_for_token/2 returns" do
    test "success when resourse is valid", %{user: user} do
      assert {:ok, user.id} == Guardian.subject_for_token(user, %{})
    end

    test "error when resource is invalid" do
      assert {:error, :unhandled_resource_type} == Guardian.subject_for_token(%{}, %{})
    end
  end

  describe "resource_from_claims/1 returns" do
    test "success when token is valid", %{user: user} do
      assert {:ok, user} == Guardian.resource_from_claims(%{"sub" => user.id})
    end

    test "error when token is invalid" do
      assert {:error, :unhandled_resource_type} == Guardian.resource_from_claims(%{})
    end
  end
end
