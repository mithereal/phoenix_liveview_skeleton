import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :api, Api.Repo,
         # IMPORTANT: Or it won't find the DB server
         socket_options: [:inet6],
         url: database_url,
         pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :api, ApiWeb.Endpoint,
         url: [host: System.get_env("RENDER_EXTERNAL_HOSTNAME") || "localhost", port: 80],
         http: [
           # Enable IPv6 and bind on all interfaces.
           # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
           # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
           # for details about using IPv6 vs IPv4 and loopback vs public addresses.
           ip: {0, 0, 0, 0, 0, 0, 0, 0},
           port: String.to_integer(System.get_env("PORT") || "4000")
         ],
         secret_key_base: secret_key_base

  # IMPORTANT: Enable the endpoint for releases
#  config :api, ApiWeb.Endpoint, server: true
end