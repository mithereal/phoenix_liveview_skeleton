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

  scope "/", ApiWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", ApiWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_email", UserSettingsController, :update_email
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    live "/", PageLive, :index
  end

  scope "/", ApiWeb do
    pipe_through [:browser]

    get "/users/force_logout", UserSessionController, :force_logout
    get "/users/log_out", UserSessionController, :delete
    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  scope "/", ApiWeb do
    pipe_through [:user_browser, :require_authenticated_user, :user]

    live "/user_dashboard", UserDashboardLive
  end

  scope "/", ApiWeb do
    pipe_through [:admin_browser, :require_authenticated_user, :user]

    live "/admin_dashboard", AdminDashboardLive
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
