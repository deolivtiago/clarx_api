defmodule ClarxApiWeb.AuthControllerTest do
  use ClarxApiWeb.ConnCase

  import ClarxApi.Factories.UserFactory

  @invalid_credentials "invalid credentials"

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "signup/2 returns success" do
    test "when the user params are valid", %{conn: conn} do
      user_params = params_for(:user)

      conn = post(conn, ~p"/signup", user: user_params)

      assert %{"data" => auth_data} = json_response(conn, :created)

      assert auth_data["user"]["email"] == user_params.email
      assert auth_data["user"]["name"] == user_params.name
      assert auth_data["token"]["type"] == "bearer"
      assert auth_data["token"]["access"]
      assert auth_data["token"]["refresh"]
    end
  end

  describe "signup/2 returns error" do
    test "when the user params are invalid", %{conn: conn} do
      user_params = %{email: "???", name: nil, password: "?"}

      conn = post(conn, ~p"/signup", user: user_params)

      assert %{"errors" => errors} = json_response(conn, :unprocessable_entity)

      assert Enum.member?(errors["email"], "has invalid format")
      assert Enum.member?(errors["name"], "can't be blank")
      assert Enum.member?(errors["password"], "should be at least 6 character(s)")
    end
  end

  describe "signin/2 returns success" do
    setup [:insert_user]

    test "when the user credentials are valid", %{conn: conn, user: user} do
      user_credentials = %{email: user.email, password: user.password}

      conn = post(conn, ~p"/signin", credentials: user_credentials)

      assert %{"data" => auth_data} = json_response(conn, :ok)

      assert auth_data["user"]["id"] == user.id
      assert auth_data["user"]["email"] == user.email
      assert auth_data["user"]["name"] == user.name
      assert auth_data["token"]["type"] == "bearer"
      assert auth_data["token"]["access"]
      assert auth_data["token"]["refresh"]
    end
  end

  describe "signin/2 returns error" do
    setup [:insert_user]

    test "when the user params are invalid", %{conn: conn} do
      user_credentials = %{email: "invalid@mail.com", password: nil}

      conn = post(conn, ~p"/signin", credentials: user_credentials)

      assert %{"errors" => errors} = json_response(conn, :unprocessable_entity)

      assert Enum.member?(errors["email"], @invalid_credentials)
      assert Enum.member?(errors["password"], @invalid_credentials)
    end
  end

  defp insert_user(_) do
    :user
    |> insert()
    |> then(&{:ok, user: &1})
  end
end
