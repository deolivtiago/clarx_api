defmodule ClarxApiWeb.Auth.ErrorHandler do
  @moduledoc false
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {:invalid_token, _}, _), do: send_resp(conn, :unauthorized, "")
  def auth_error(conn, {:no_resource_found, _}, _), do: send_resp(conn, :unauthorized, "")
  def auth_error(conn, {:unauthenticated, _}, _), do: send_resp(conn, :forbidden, "")
  def auth_error(conn, {:already_authenticated, _}, _), do: send_resp(conn, :forbidden, "")
end
