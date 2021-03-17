# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

signing_salt = "4532fds242"
session_key = "fsdfsdce54"
secret_key_base = "4rIGvcjT1Li5zkXo0ZIEjoaSKzDfhCiMVKvgOjinBRT2J1wJxUkNsCGlZd0PfD8+"
host = "localhost"

config :api,
  ecto_repos: [Api.Repo]

# Configures the endpoint
config :api, ApiWeb.Endpoint,
  url: [host: host],
  secret_key_base: secret_key_base,
  render_errors: [view: ApiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Api.PubSub,
  live_view: [signing_salt: signing_salt],
  session_signing_salt: signing_salt,
  session_key: session_key,
  session_store: :cookie,
  origins: [host],
  allow_credentials: true,
  max_age: 600

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
