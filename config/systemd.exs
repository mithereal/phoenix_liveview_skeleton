use Mix.Config

config :mix_systemd,
  env_files: [
    # Read environment vars from file /srv/foo/etc/environment
    ["-", :deploy_dir, "/etc/environment"]
  ],
  # Set individual env vars
  env_vars: [
    "PORT=4000"
  ],
  # Run app under this OS user, default is name of app
  app_user: "platform",
  app_group: "platform"

config :mix_deploy,
  app_user: "git",
  app_group: "git",
  # When deploying, copy config/environment to /etc/foo/environment
  copy_files: [
    %{
      src: "config/prod",
      dst: [:deploy_dir, "/etc/platform"],
      user: "$DEPLOY_USER",
      group: "$APP_GROUP",
      mode: "640"
    }
  ],
  create_dirs: [
    %{
      path: [:deploy_dir, "/etc/platform"],
      user: "$DEPLOY_USER",
      group: "$APP_GROUP",
      mode: "750"
    }
  ],
  # Generate these scripts in bin
  templates: [
    "init-local",
    "create-users",
    "create-dirs",
    "copy-files",
    "enable",
    "release",
    "restart",
    "rollback",
    "start",
    "stop"
  ]
