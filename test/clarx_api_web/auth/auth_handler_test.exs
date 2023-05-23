defmodule ClarxApiWeb.Auth.AuthHandlerTest do
  use ClarxApi.DataCase

  import ClarxApi.Factories.UserFactory

  alias ClarxApiWeb.Auth.AuthHandler
  alias ClarxApiWeb.Auth.Guardian

  @invalid_credentials "invalid credentials"

  setup do
    :user
    |> insert()
    |> then(&{:ok, user: &1})
  end

  describe "authenticate_user/1 returns ok" do
    test "when user credentials are valid", %{user: user} do
      user_credentials = %{"email" => user.email, "password" => user.password}

      assert {:ok, auth} = AuthHandler.authenticate_user(user_credentials)

      assert auth.user.id == user.id
      assert auth.user.name == user.name
      assert auth.user.email == user.email
      assert auth.user.password_hash == user.password_hash
      assert auth.token.type == "bearer"
      assert {:ok, %{"typ" => "access"}} = Guardian.decode_and_verify(auth.token.access)
      assert {:ok, %{"typ" => "refresh"}} = Guardian.decode_and_verify(auth.token.refresh)
    end
  end

  describe "authenticate_user/1 returns error" do
    test "when user credentials are invalid" do
      assert {:error, changeset} = AuthHandler.authenticate_user(%{})
      errors = errors_on(changeset)

      refute changeset.valid?
      assert Enum.member?(errors.email, @invalid_credentials)
      assert Enum.member?(errors.password, @invalid_credentials)
    end

    test "when user email is invalid", %{user: user} do
      user_credentials = %{"email" => "invalid@mail.com", "password" => user.password}

      assert {:error, changeset} = AuthHandler.authenticate_user(user_credentials)
      errors = errors_on(changeset)

      refute changeset.valid?
      assert Enum.member?(errors.email, @invalid_credentials)
      assert Enum.member?(errors.password, @invalid_credentials)
    end

    test "when user email is null", %{user: user} do
      user_credentials = %{"email" => nil, "password" => user.password}

      assert {:error, changeset} = AuthHandler.authenticate_user(user_credentials)
      errors = errors_on(changeset)

      refute changeset.valid?
      assert Enum.member?(errors.email, @invalid_credentials)
      assert Enum.member?(errors.password, @invalid_credentials)
    end

    test "when user email is empty", %{user: user} do
      user_credentials = %{"email" => "", "password" => user.password}

      assert {:error, changeset} = AuthHandler.authenticate_user(user_credentials)
      errors = errors_on(changeset)

      refute changeset.valid?
      assert Enum.member?(errors.email, @invalid_credentials)
      assert Enum.member?(errors.password, @invalid_credentials)
    end

    test "when user email is not given", %{user: user} do
      user_credentials = %{"password" => user.password}

      assert {:error, changeset} = AuthHandler.authenticate_user(user_credentials)

      errors = errors_on(changeset)
      refute changeset.valid?
      assert Enum.member?(errors.email, @invalid_credentials)
      assert Enum.member?(errors.password, @invalid_credentials)
    end

    test "when user password is invalid", %{user: user} do
      user_credentials = %{"email" => user.email, "password" => "invalid_password"}

      assert {:error, changeset} = AuthHandler.authenticate_user(user_credentials)

      errors = errors_on(changeset)
      refute changeset.valid?
      assert Enum.member?(errors.email, @invalid_credentials)
      assert Enum.member?(errors.password, @invalid_credentials)
    end

    test "when user password is null", %{user: user} do
      user_credentials = %{"email" => user.email, "password" => nil}

      assert {:error, changeset} = AuthHandler.authenticate_user(user_credentials)

      errors = errors_on(changeset)
      refute changeset.valid?
      assert Enum.member?(errors.email, @invalid_credentials)
      assert Enum.member?(errors.password, @invalid_credentials)
    end

    test "when user password is empty", %{user: user} do
      user_credentials = %{"email" => user.email, "password" => ""}

      assert {:error, changeset} = AuthHandler.authenticate_user(user_credentials)

      errors = errors_on(changeset)
      refute changeset.valid?
      assert Enum.member?(errors.email, @invalid_credentials)
      assert Enum.member?(errors.password, @invalid_credentials)
    end

    test "when user password is not given", %{user: user} do
      user_credentials = %{"email" => user.email}

      assert {:error, changeset} = AuthHandler.authenticate_user(user_credentials)

      errors = errors_on(changeset)
      refute changeset.valid?
      assert Enum.member?(errors.email, @invalid_credentials)
      assert Enum.member?(errors.password, @invalid_credentials)
    end
  end
end
