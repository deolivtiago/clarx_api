defmodule ClarxApiWeb.Router do
  use ClarxApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ClarxApiWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:clarx_api, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
