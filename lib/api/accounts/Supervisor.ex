defmodule Api.User.Server.Supervisor do
  use DynamicSupervisor

  alias Api.User.Server.Supervisor, as: SUPERVISOR
  alias Api.User.Server, as: SERVER

  @registry_name :user_registry
  @name :user_supervisor

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: @name)
  end

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, [], name: @name)
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start(user \\ nil) do

    child_spec = {Api.User.Server, user}

    DynamicSupervisor.start_child(@name, child_spec)

    Task.async(fn -> Api.Admin.refresh_users() end)

    {:ok, "success"}
  end

  def stop(id) do
    SERVER.shutdown(id)

    {:ok, "success"}
  end

  def whereis(id) do
    case Registry.lookup(@registry_name, id) do
      [{pid, _}] -> pid
      [] -> nil
    end
  end

  def exists?(id) do
    case Registry.lookup(@registry_name, id) do
      [] -> false
      _ -> true
    end
  end

  def list do
    keys =
      Supervisor.which_children(@name)
      |> Enum.map(fn {_, account_proc_pid, _, _} ->
        Registry.keys(@registry_name, account_proc_pid)
        |> List.first()
      end)

    keys
    |> Enum.sort()
  end

  def process_exists?(id) do
    case Registry.lookup(@registry_name, id) do
      [] -> false
      _ -> true
    end
  end
end
