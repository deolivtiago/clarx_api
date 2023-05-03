defmodule ClarxApi.Accounts.User.Delete do
  @moduledoc false
  alias ClarxApi.Accounts.User
  alias ClarxApi.Repo

  @doc false
  def call(%User{} = user), do: Repo.delete(user)
end
