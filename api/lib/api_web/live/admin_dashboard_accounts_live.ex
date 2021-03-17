defmodule ApiWeb.AdminDashboardAccountsLive do
  use ApiWeb, :live_view
  use ApiWeb, :user_auth

  @minute_ticks 60000

  @impl true
  def mount(_params, session, socket) do
    users = Api.Accounts.User |> Api.Repo.all
    socket = assign_defaults(session, socket)
    socket = assign(socket, :users, users)

    IO.inspect users
#    socket = assign(socket, :last_visited, __MODULE__)

    if connected?(socket), do: Api.Admin.subscribe("Admin", "Users")

    {:ok, socket}
  end


  @impl true
  def render(assigns) do
    ~L"""

<div class="grid grid-cols-3 md:grid-cols-3">
      <%=  for x <- @users do %>
       <%=  live_component(@socket,  ApiWeb.UserComponent, user: x) %>
       <% end %>

 </div>
    """
  end

    def handle_info({_requesting_module, [:data, :updated], %{users: users}}, socket) do

   socket = assign(socket, :users, users)


    {:noreply, socket}
  end



end
