defmodule ApiWeb.AdminDashboardLive do
  use ApiWeb, :live_view
  use ApiWeb, :user_auth

  @minute_ticks 60000

  @impl true
  def mount(_params, session, socket) do
    {uptime, _} = :erlang.statistics(:wall_clock)
    uptime = Float.ceil(uptime / @minute_ticks)
    active_users = Enum.count(Api.User.Server.Supervisor.list())
    total_users = Api.Accounts.count_users()
    errors = 0
    socket = assign_defaults(session, socket)
    socket = assign(socket, :uptime, uptime)
    socket = assign(socket, :active_users, active_users)
    socket = assign(socket, :total_users, total_users)
    socket = assign(socket, :total_errors, errors)
    #    socket = assign(socket, :last_visited, __MODULE__)

    if connected?(socket), do: Api.Admin.subscribe("Admin", "Dashboard")

    Process.send_after(self(), {:tick, socket}, @minute_ticks)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
       <%=  live_component(@socket,  ApiWeb.AnalyticsComponent, assigns) %>
    """
  end

  def handle_info(
        {_requesting_module, [:data, :updated],
         %{active_users: active_users, total_users: total_users}},
        socket
      ) do
    socket = assign(socket, :active_users, Enum.count(active_users))

    socket = assign(socket, :total_users, total_users)

    {:noreply, socket}
  end

  def handle_info({:tick, socket}, state) do
    {uptime, _} = :erlang.statistics(:wall_clock)

    uptime = Float.ceil(uptime / @minute_ticks)

    socket = assign(socket, :uptime, uptime)

    Process.send_after(self(), {:tick, socket}, @minute_ticks)

    {:noreply, socket}
  end
end
