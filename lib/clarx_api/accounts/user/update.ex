defmodule ClarxApi.Accounts.User.Update do
  @moduledoc false
  alias ClarxApi.Accounts.User
  alias ClarxApi.Repo

  @doc false
  def call(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
end
