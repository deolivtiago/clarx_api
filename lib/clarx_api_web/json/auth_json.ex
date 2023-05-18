defmodule ClarxApiWeb.AuthJSON do
  @moduledoc """
  Renders authentication data.
  """

  alias ClarxApiWeb.UserJSON

  @doc """
  Renders authentication.
  """
  def show(%{auth: %{token: token} = auth}) do
    auth
    |> UserJSON.show()
    |> Map.update(:data, nil, &Map.new(user: &1, token: token))
  end
end
