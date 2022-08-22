# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :api, :generators, context_app: :api

signing_salt = "4532fds242"
session_key = "fsdfsdce54"
secret_key_base = "4rIGvcjT1Li5zkXo0ZIEjoaSKzDfhCiMVKvgOjinBRT2J1wJxUkNsCGlZd0PfD8+"
host = "localhost"

config :api,
  ecto_repos: [Api.Repo],
  google_play_id: ""

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

config :smlr, cache_opts: %{enable: false, timeout: :infinity, limit: nil}
config :tesla, adapter: Tesla.Adapter.Hackney

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :dart_sass,
       version: "1.49.11",
       default: [
         args: ~w(css/root.scss css/root.css.tailwind),
         cd: Path.expand("../assets", __DIR__)
       ],
       user: [
         args: ~w(css/user.scss css/user.css.tailwind),
         cd: Path.expand("../assets", __DIR__)
       ],
       admin: [
         args: ~w(css/admin.scss css/admin.css.tailwind),
         cd: Path.expand("../assets", __DIR__)
       ]

config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/root.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ],
  user: [
    args:
      ~w(js/user.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ],
  admin: [
    args:
      ~w(js/admin.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.1.6",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/root.css.tailwind
      --output=../priv/static/assets/root.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ],
  user: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/user.css.tailwind
      --output=../priv/static/assets/user.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ],
  admin: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/admin.css.tailwind
      --output=../priv/static/assets/admin.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
