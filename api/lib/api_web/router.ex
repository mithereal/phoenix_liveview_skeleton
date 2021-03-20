defmodule ApiWeb.Router do
  use ApiWeb, :router
  use ApiWeb, :user_auth

  alias ApiWeb.Plug.EnsureRole

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ApiWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug(Smlr, enable: false)
  end

  pipeline :admin_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ApiWeb.LayoutView, "admin.html"}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug(Smlr, enable: false)
  end

  pipeline :user_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ApiWeb.LayoutView, "user.html"}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug(Smlr, enable: false)
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug(Smlr, enable: false)
  end

  pipeline :api_disabled do
    plug(:accepts, ["json"])
    plug(Smlr, enable: false)
  end

  pipeline :api_ignore_weight do
    plug(:accepts, ["json"])

    plug(Smlr,
      ignore_client_weight: true,
      compressors: [Smlr.Compressor.Gzip, Smlr.Compressor.Deflate, Smlr.Compressor.Brotli]
    )
  end

  pipeline :api_types do
    plug(:accepts, ["json"])

    plug(Smlr,
      all_types: false
    )
  end

  pipeline :api_cache do
    plug(:accepts, ["json"])

    plug(Smlr,
      ignore_client_weight: true,
      cache_opts: %{
        enable: true,
        timeout: :infinity,
        limit: nil
      }
    )
  end

  pipeline :user do
    plug EnsureRole, [:admin, :user]
  end

  pipeline :admin do
    plug EnsureRole, :admin
  end

  ## Authentication routes

  scope "/user", ApiWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/register", UserRegistrationController, :new
    post "/register", UserRegistrationController, :create
    get "/log_in", UserSessionController, :new
    post "/log_in", UserSessionController, :create
    get "/reset_password", UserResetPasswordController, :new
    post "/reset_password", UserResetPasswordController, :create
    get "/reset_password/:token", UserResetPasswordController, :edit
    put "/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/user/settings", ApiWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/", UserSettingsController, :edit
    put "/update_password", UserSettingsController, :update_password
    put "/update_email", UserSettingsController, :update_email
    get "/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/user", ApiWeb do
    pipe_through [:browser]

    get "/force_logout", UserSessionController, :force_logout
    get "/log_out", UserSessionController, :delete
    delete "/log_out", UserSessionController, :delete
    get "/confirm", UserConfirmationController, :new
    post "/confirm", UserConfirmationController, :create
    get "/confirm/:token", UserConfirmationController, :confirm
  end

  scope "/home", ApiWeb do
    pipe_through [:user_browser, :require_authenticated_user, :user]

    live "/", UserDashboardLive
  end

  scope "/admin", ApiWeb do
    pipe_through [:admin_browser, :require_authenticated_user, :admin]

    live "/", AdminDashboardLive
    live "/analytics", AdminDashboardAnalyticsLive
    live "/accounts", AdminDashboardAccountsLive
  end

  scope "/", ApiWeb do
    pipe_through [:browser]

    live "/", PageLive
  end

  # Other scopes may use custom stacks.

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ApiWeb.Telemetry
    end
  end
end
