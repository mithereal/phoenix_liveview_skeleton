defmodule Api.Error.Server do
  require Logger

  use GenServer

  alias Api.Error.Server, as: SERVER

  @name :error_server
  @restart_time 60 * 1000 * 60

    defstruct errors: %{}


  def child_spec(init) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [init]},
      restart: :transient,
      type: :worker
    }
  end


  ## client funs

  def show() do
    try do
      GenServer.call(@name, :show)
    catch
      :exit, _ -> {:error, "user_doesnt_exist"}
    end
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  @impl true
  def init([]) do
    initial_state = %__MODULE__{
      errors: []
    }

Logger.info "Started: Error Queue"
Process.send_after(Task.shutdown(@name, :brutal_kill), @restart_time)

    {:ok, initial_state}
  end


  def start_server() do
    try do
      GenServer.call(@name, {:start_server})
    catch
      :exit, _ -> {:error, "server_already_started"}
    end
  end

  def shutdown() do
    try do
      GenServer.cast(@name, :shutdown)
      {:ok, to_string(@name) <> " has been shutdown"}
    catch
      :exit, _ -> {:error, "error_doesnt_exist"}
    end
  end

  ## server funs



  def handle_info(:start_server, state) do

    {:noreply, state}
  end

  def handle_call(
        :shutdown,
        _from,
        state
      ) do
    {:stop, {:ok, "Server Normal Shutdown"}, state.errors}
  end

  def handle_cast(
        :shutdown,
        state
      ) do
    {:stop, :normal, state}
  end

    def handle_call(
        :show,
        _from,
        state
      ) do

    {:reply, {:ok, state}, state}
  end


end
