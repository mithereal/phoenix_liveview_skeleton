defmodule ReleaseTasks.Migrate do
  @moduledoc "Mix task to run Ecto database migrations"

  #Name of app as used by Application.get_env
  @app :api
  # Name of app repo module
  @repo_module Api.Repo

  def run(args \\ [])

  def run(_args) do
    ext_name = @app |> to_string |> String.replace("_", "-")
    config_dir = Path.join("/etc", ext_name)

    # Read config.exs if present
    config_exs = Path.join(config_dir, "config.exs")
    app_env =
      case File.exists?(config_exs) do
        true ->
          IO.puts("==> Loading config file #{config_exs}")
          Config.Reader.merge([], Config.Reader.read!(config_exs))

        _ ->
          app_env
      end

    # Read TOML config if present 
    config_toml = Path.join(config_dir, "config.toml")
    app_env =
      case File.exists?(config_toml) do
        true ->
          IO.puts("==> Loading config file #{config_toml}")
          TomlConfigProvider.load(config, config_toml)

        _ ->
          app_env
      end

    Application.put_env(@app, @repo_module, app_env[@app][@repo_module])

    # Start requisite apps
    IO.puts("==> Starting applications..")

    for app <- [:crypto, :ssl, :postgrex, :ecto, :ecto_sql] do
      {:ok, res} = Application.ensure_all_started(app)
      IO.puts("==> Started #{app}: #{inspect(res)}")
    end

    # Start repo
    IO.puts("==> Starting repo")
    {:ok, _pid} = apply(@repo_module, :start_link, [[pool_size: 2, log: :info, log_sql: true]])

    # Run migrations for the repo
    IO.puts("==> Running migrations")
    priv_dir = Application.app_dir(@app, "priv")
    migrations_dir = Path.join([priv_dir, "repo", "migrations"])

    opts = [all: true]
    config = apply(@repo_module, :config, [])
    pool = config[:pool]

    if function_exported?(pool, :unboxed_run, 2) do
      pool.unboxed_run(@repo_module, fn ->
        Ecto.Migrator.run(@repo_module, migrations_dir, :up, opts)
      end)
    else
      Ecto.Migrator.run(@repo_module, migrations_dir, :up, opts)
    end

    # Shut down
    :init.stop()
  end
end