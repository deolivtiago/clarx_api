defmodule ClarxApiWeb.Auth.AuthHandler do
  @moduledoc """
  Auth handler
  """
  alias Argon2
  alias ClarxApi.Accounts
  alias ClarxApi.Accounts.User
  alias ClarxApiWeb.Auth.Guardian
  alias Ecto.Changeset

  @invalid_credentials "invalid credentials"

  def authenticate_user(%{"email" => email, "password" => password}) do
    email
    |> verify_email()
    |> verify_password(password)
    |> generate_token()
  end

  def authenticate_user(_invalid_credentials), do: user_credentials_error()

  defp verify_email(email) do
    case Accounts.get_user(email: email) do
      {:ok, user} -> user
      {:error, changeset} -> changeset
    end
  end

  defp verify_password(%User{} = user, password) when not is_nil(password) do
    case Argon2.verify_pass(password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, user}
    end
  end

  defp verify_password(changeset, _password) do
    Argon2.no_user_verify()
    {:error, changeset}
  end

  defp generate_token({:error, _user_or_changeset}), do: user_credentials_error()

  defp generate_token({:ok, user}) do
    {:ok,
     %{
       user: user,
       token:
         Map.new()
         |> Map.put(:type, "bearer")
         |> put_token(:access, user)
         |> put_token(:refresh, user)
     }}
  end

  defp put_token(map, :access, user) do
    with {:ok, token, _claims} <-
           Guardian.encode_and_sign(user, %{}, token_type: "access", ttl: {1, :hour}) do
      Map.put(map, :access, token)
    end
  end

  defp put_token(map, :refresh, user) do
    with {:ok, token, _claims} <-
           Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {48, :hour}) do
      Map.put(map, :refresh, token)
    end
  end

  defp user_credentials_error do
    %User{}
    |> Accounts.change_user()
    |> Changeset.add_error(:email, @invalid_credentials)
    |> Changeset.add_error(:password, @invalid_credentials)
    |> then(&{:error, &1})
  end
end
