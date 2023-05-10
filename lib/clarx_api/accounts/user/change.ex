defmodule ClarxApi.Accounts.User.Change do
  @moduledoc false
  alias ClarxApi.Accounts.User

  @doc false
  def call(%User{} = user, attrs \\ %{}), do: User.changeset(user, attrs)
end
