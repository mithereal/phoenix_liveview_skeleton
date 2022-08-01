defmodule Api.Error.Server.Supervisor do
  use DynamicSupervisor

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

  def stop(id \\ false) do
    SERVER.shutdown()

    {:ok, "success"}
  end
end
