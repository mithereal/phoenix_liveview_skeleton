# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Distillery.Releases.Config,
  # This sets the default release built by `mix release`
  default_release: :api,
  # This sets the default environment used by `mix release`
  default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/config/distillery.html

# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  # If you are running Phoenix, you should make sure that
  # server: true is set and the code reloader is disabled,
  # even in dev mode.
  # It is recommended that you build with MIX_ENV=prod and pass
  # the --env flag to Distillery explicitly if you want to use
  # dev mode.
  set(dev_mode: true)
  set(include_erts: false)
  set(cookie: :"`L[1E5}aoku1O]BNc]M7&N6j6!}j7GL{TEsp~Oc4QTf%sTnr(8otCVIcl_*JTHT7")
end

environment :prod do
  set(include_erts: true)
  set(include_src: false)
  set(cookie: :"Rq~`^;R5%M%fA$mcvM2}_~:F6xX34ZQUl{K=WkXSuD6XNL>T*jEEct=Ch76*O:ol")
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :api do
  set(
    version:
      with {:ok, body} <- File.read("../package.json"),
           {:ok, json} <- Jason.decode(body) do
        json["version"]
      end
  )

  set(
    applications: [
      :api
    ]
  )

  set(
    commands: [
      migrate: "rel/commands/database_migrate.sh",
      seed: "rel/commands/seed.sh"
    ]
  )

  config_files = [
    "config.exs"
  ]

  set(
    config_providers:
      Enum.map(config_files, fn file ->
        {Distillery.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/#{file}"]}
      end)
  )

  set(
    overlays: Enum.map(config_files, fn file -> {:copy, "rel/config/#{file}", "etc/#{file}"} end)
  )
end
