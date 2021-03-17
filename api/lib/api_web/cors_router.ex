defmodule ApiWeb.CORS do
  use Corsica.Router,
    origins: Application.get_env(:api, :origins, []),
    allow_credentials: Application.get_env(:api, :allow_credentials, true),
    max_age: Application.get_env(:api, :max_age, 600)

  resource("/*")

  # We can override single settings as well.
  resource("/public/*", allow_credentials: false)
end
