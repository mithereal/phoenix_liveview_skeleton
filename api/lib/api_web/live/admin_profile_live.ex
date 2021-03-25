defmodule ApiWeb.AdminProfileLive do
  use ApiWeb, :live_view
  use ApiWeb, :user_auth

  @impl true
  def mount(_params, session, socket) do

    socket = assign_defaults(session, socket)
    socket = assign(socket, :user_data,  socket.assigns.current_user)


    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
       <%=  live_component(@socket,  ApiWeb.ProfileComponent, assigns) %>
    """
  end

  def handle_info(
        {_requesting_module, [:data, :updated],_session},
        socket
      ) do

    {:noreply, socket}
  end


end
