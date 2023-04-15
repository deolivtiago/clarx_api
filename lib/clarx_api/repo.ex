defmodule ClarxApi.Repo do
  use Ecto.Repo,
    otp_app: :clarx_api,
    adapter: Ecto.Adapters.Postgres
end
