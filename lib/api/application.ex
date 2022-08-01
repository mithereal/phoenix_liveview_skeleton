defmodule Api.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Api.Repo,
      # Start the Telemetry supervisor
      ApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Api.PubSub},
      # Start the Endpoint (http/https)
      ApiWeb.Endpoint,
      # Start user Registry
      {Registry, keys: :unique, name: :user_registry},
      # Start the User supervisor
      Api.User.Server.Supervisor,
      Api.Error.Server.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Api.Supervisor]

    Supervisor.start_link(children, opts)
    |> setup_role_tables()
  end

  def setup_role_tables(response) do
    alias Ecto.Multi

    multi =
      Multi.new()
      |> Multi.run(:ability_delete, fn repo, _data ->
        Terminator.Ability.build("delete_accounts", "Delete accounts of users")
        |> repo.insert()
      end)
      |> Multi.run(:ability_ban, fn repo, _data ->
        Terminator.Ability.build("ban_accounts", "Ban users")
        |> repo.insert()
      end)
      |> Multi.run(:admin_role, fn repo, _data ->
        Terminator.Role.build("admin", [], "Site administrator")
        |> repo.insert()
      end)
      |> Multi.run(:user_role, fn repo, _data ->
        Terminator.Role.build("user", [], "Site user")
        |> repo.insert()
      end)

    case Api.Repo.transaction(multi) do
      {:ok, %{admin_role: role, ability_delete: ability_delete, ability_ban: ability_ban}} ->
        Terminator.Role.grant(role, ability_delete)
        Terminator.Role.grant(role, ability_ban)
        :ok

      error ->
        error
    end

    response
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  @version Mix.Project.config()[:version]

  def version, do: @version
end
