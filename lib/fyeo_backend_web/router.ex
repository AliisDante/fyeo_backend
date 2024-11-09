defmodule FyeoBackendWeb.Router do
  use FyeoBackendWeb, :router

  import FyeoBackendWeb.UserPlugs
  import FyeoBackendWeb.APIPlugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FyeoBackendWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :add_acao_header
  end

  pipeline :authenticated_user do
    plug :fetch_user
    plug :enforce_authenticated_user
  end

  scope "/", FyeoBackendWeb do
    pipe_through :api

    post "/organisation_signup", OrganisationController, :signup

    # post "/signup", UserController, :signup
    post "/login", UserController, :login

    get "/share/:filename", SharedFilesController, :get_file

    scope "/", FyeoBackendWeb do
      pipe_through :authenticated_user
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", FyeoBackendWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:fyeo_backend, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FyeoBackendWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
