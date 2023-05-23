defmodule ClarxApiWeb.AuthController do
  @moduledoc """
  Handles auth requests
  """
  use ClarxApiWeb, :controller

  alias ClarxApi.Accounts
  alias ClarxApiWeb.Auth.AuthHandler

  action_fallback ClarxApiWeb.FallbackController

  @doc """
  Handles requests to sign up.
  """
  def signup(conn, %{"user" => user_params}) do
    with {:ok, _user} <- Accounts.create_user(user_params),
         {:ok, auth} <- AuthHandler.authenticate_user(user_params) do
      conn
      |> put_status(:created)
      |> render(:show, auth: auth)
    end
  end

  @doc """
  Handles requests to sign in.
  """
  def signin(conn, %{"credentials" => user_credentials}) do
    with {:ok, auth} <- AuthHandler.authenticate_user(user_credentials) do
      render(conn, :show, auth: auth)
    end
  end
end
