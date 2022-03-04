# This file is responsible for setting all release runtime configuration.

use Mix.Config

log_level =
  case System.get_env("LOG_LEVEL") do
    "debug" -> :debug
    "warn" -> :warn
    "error" -> :error
    _ -> :info
  end

config :logger, level: log_level
