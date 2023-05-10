defmodule ClarxApi.Accounts.User.List do
  @moduledoc false
  alias ClarxApi.Accounts.User
  alias ClarxApi.Repo

  @doc false
  def call, do: Repo.all(User)
end
