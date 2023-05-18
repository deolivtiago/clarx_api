defmodule ClarxApiWeb.Auth.ErrorHandlerTest do
  use ClarxApiWeb.ConnCase, async: true

  alias ClarxApiWeb.Auth.ErrorHandler

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "auth_error/2 returns unauthorized" do
    test "when token is invalid", %{conn: conn} do
      conn = ErrorHandler.auth_error(conn, {:invalid_token, :invalid_token}, [])

      assert response(conn, :unauthorized)
    end

    test "when resource is not found", %{conn: conn} do
      conn = ErrorHandler.auth_error(conn, {:no_resource_found, :no_resource_found}, [])

      assert response(conn, :unauthorized)
    end
  end

  describe "auth_error/2 returns forbidden" do
    test "when request must be authenticated", %{conn: conn} do
      conn = ErrorHandler.auth_error(conn, {:unauthenticated, :unauthenticated}, [])

      assert response(conn, :forbidden)
    end

    test "when request must be unauthenticated", %{conn: conn} do
      conn = ErrorHandler.auth_error(conn, {:already_authenticated, :already_authenticated}, [])

      assert response(conn, :forbidden)
    end
  end
end
