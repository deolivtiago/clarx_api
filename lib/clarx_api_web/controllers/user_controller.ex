defmodule ClarxApiWeb.UserController do
  @moduledoc """
  Handles user requests
  """
  use ClarxApiWeb, :controller

  alias ClarxApi.Accounts

  action_fallback ClarxApiWeb.FallbackController

  @doc """
  Handles request to list users.
  """
  def index(conn, _params) do
    users = Accounts.list_users()

    render(conn, :index, users: users)
  end

  @doc """
  Handles requests to create an user.
  """
  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/users/#{user}")
      |> render(:show, user: user)
    end
  end

  @doc """
  Handles requests to show an user.
  """
  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Accounts.get_user(id) do
      render(conn, :show, user: user)
    end
  end

  @doc """
  Handles requests to update an user.
  """
  def update(conn, %{"id" => id, "user" => user_params}) do
    with {:ok, user} <- Accounts.get_user(id),
         {:ok, user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  @doc """
  Handles requests to delete an user.
  """
  def delete(conn, %{"id" => id}) do
    with {:ok, user} <- Accounts.get_user(id),
         {:ok, _user} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
