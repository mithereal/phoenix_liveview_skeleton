defmodule ApiWeb.AdminDashboardAnalyticsLive do
  use ApiWeb, :live_view
  use ApiWeb, :user_auth

  @minute_ticks 60000

  @impl true
  def mount(_params, session, socket) do
    {uptime, _} = :erlang.statistics(:wall_clock)
    uptime = Float.round(uptime / @minute_ticks,0)
    active_users = Enum.count(Api.User.Server.Supervisor.list())
    total_users = Api.Accounts.count_users()
    socket = assign_defaults(session, socket)
    socket = assign(socket, :uptime, uptime)
    socket = assign(socket, :active_users, active_users)
    socket = assign(socket, :total_users, total_users)
      socket = assign(socket, :total_errors, 0)
#    socket = assign(socket, :last_visited, __MODULE__)

    if connected?(socket), do: Api.Admin.subscribe("Admin", "Analytics")
    if connected?(socket), do: Api.Admin.subscribe("Admin", "Errors")

     Process.send_after(self(), {:tick, socket}, @minute_ticks)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
       <%=  live_component(@socket,  ApiWeb.AnalyticsComponent, assigns) %>

    """
  end

    def handle_info({_requesting_module, [:data, :updated], %{active_users: active_users, total_users: total_users}}, socket) do

   socket = assign(socket, :active_users, Enum.count(active_users))

    socket = assign(socket, :total_users, total_users)

    {:noreply, socket}
  end

      def handle_info({_requesting_module, [:data, :updated], %{errors: errors}}, socket) do

   socket = assign(socket, :total_errors, Enum.count(errors))

    {:noreply, socket}
  end


  def handle_info({:tick, socket}, state) do

{uptime, _} = :erlang.statistics(:wall_clock)

    uptime = Float.round(uptime / @minute_ticks, 0)

    socket = assign(socket, :uptime, uptime)

     Process.send_after(self(), {:tick, socket}, @minute_ticks)

    {:noreply, socket}
  end


end
