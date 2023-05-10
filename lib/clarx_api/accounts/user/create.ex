defmodule ClarxApi.Accounts.User.Create do
  @moduledoc false
  alias ClarxApi.Accounts.User
  alias ClarxApi.Repo

  @doc false
  def call(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
