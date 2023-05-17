defmodule ClarxApiWeb.Auth.Pipeline do
  @moduledoc false
  use Guardian.Plug.Pipeline,
    otp_app: :clarx_api,
    module: ClarxApiWeb.Auth.Guardian,
    error_handler: ClarxApiWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: false
  plug Guardian.Plug.EnsureAuthenticated
end
