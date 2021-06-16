defmodule Api.Error.Server.Supervisor do
  use DynamicSupervisor

  alias Api.Error.Server.Supervisor, as: SUPERVISOR
  alias Api.Error.Server, as: SERVER

  @name :error_supervisor

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

  def start() do
    errors = %{errors: []}

    child_spec = {Api.Error.Server, errors}

    DynamicSupervisor.start_child(@name, child_spec)

    Task.async(fn -> Api.Admin.refresh_errors() end)

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

  def process_exists?(hash) do
    case Registry.lookup(@registry_name, hash) do
      [] -> false
      _ -> true
    end
  end
end
