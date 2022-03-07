defmodule Api.ReleaseTasks do
  @moduledoc """
  This module exposes commands that can be run without mix, using distillery.
  Here we have a migrate command that runs all of the migrations for the DB.

  Based on https://github.com/bitwalker/distillery/blob/master/docs/guides/running_migrations.md
  """
  alias Api.Repo

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql,
    :hackney,
    :logger
  ]

  def migrate do
    start_services()

    run_migrations()

    stop_services()
  end

  defp start_services do
    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo for app
    IO.puts("Starting repos..")

    Repo.start_link(pool_size: 2)
  end

  defp stop_services do
    IO.puts("Success!")
    :init.stop()
  end

  defp run_migrations do
    app = Keyword.get(Repo.config(), :otp_app)
    IO.puts("Running migrations for #{app}")
    migrations_path = priv_path_for(Repo, "migrations")
    Ecto.Migrator.run(Repo, migrations_path, :up, all: true)
  end

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config(), :otp_app)

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    priv_dir = "#{:code.priv_dir(app)}"

    Path.join([priv_dir, repo_underscore, filename])
  end
end
