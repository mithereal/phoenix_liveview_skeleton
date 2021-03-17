defmodule Api.User.Server do
  require Logger

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

  def show(hash) do
    try do
      GenServer.call(via_tuple(hash), :show)
    catch
      :exit, _ -> {:error, "user_doesnt_exist"}
    end
  end

  def start_link(user) do
    GenServer.start_link(__MODULE__, [user], name: via_tuple(user.hash))
  end

  @impl true
  def init([user]) do
    initial_state = %__MODULE__{
      user: user
    }
Logger.info "Started: User Server"
    {:ok, initial_state}
  end

  def via_tuple(hash) do
    {:via, Registry, {@public_registry_name, hash}}
  end

  def start_server(hash) do
    try do
      GenServer.call(via_tuple(hash), {:start_server})
    catch
      :exit, _ -> {:error, "user_doesnt_exist"}
    end
  end

  def shutdown(hash) do
    try do
      GenServer.cast(via_tuple(hash), :shutdown)
      {:ok, to_string(hash) <> " has been shutdown"}
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
    {:stop, {:ok, "User Server Normal Shutdown"}, state.user.hash}
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


end
