defmodule Api.User.Server do
  require Logger

  use Terminator
  use GenServer

  alias Api.User.Server, as: SERVER

  @name :user_server
  @public_registry_name :user_registry

  defstruct user: %{}

  def child_spec(init) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [init]},
      restart: :transient,
      type: :worker
    }
  end

  ## client funs

  def show(id) do
    try do
      GenServer.call(via_tuple(id), :show)
    catch
      :exit, _ -> {:error, "user_doesnt_exist"}
    end
  end

  def update(id, data) do
    try do
      GenServer.call(via_tuple(id), {:update, data})
    catch
      :exit, _ -> {:error, "user_doesnt_exist"}
    end
  end

  def start_link(user) do
    GenServer.start_link(__MODULE__, [user], name: via_tuple(user.id))
  end

  @impl true
  def init([user]) do
    initial_state = %__MODULE__{
      user: user
    }

    Logger.info("Started: User Server")

    load_and_authorize_performer(user)

    {:ok, initial_state}
  end

  def via_tuple(id) do
    {:via, Registry, {@public_registry_name, id}}
  end

  def start_server(id) do
    try do
      GenServer.call(via_tuple(id), {:start_server})
    catch
      :exit, _ -> {:error, "user_doesnt_exist"}
    end
  end

  def shutdown(user) do
    try do
      Logger.info("Stop: User Server")
      GenServer.cast(via_tuple(user.id), :shutdown)
      {:ok, to_string(user.id) <> " has been shutdown"}
    catch
      :exit, _ -> {:error, "user_doesnt_exist"}
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
    Task.async(fn -> Api.Admin.refresh_users() end)
    {:stop, :normal, state.user.id}
  end

  def handle_cast(
        :shutdown,
        state
      ) do
    Task.async(fn -> Api.Admin.refresh_users() end)
    {:stop, :normal, state}
  end

  def handle_call(
        :show,
        _from,
        state
      ) do
    {:reply, {:ok, state}, state}
  end

  def handle_call(
        {:update, data},
        _from,
        state
      ) do
    {:reply, {:ok, data}, data}
  end
end
