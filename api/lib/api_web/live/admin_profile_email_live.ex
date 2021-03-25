defmodule ApiWeb.AdminProfileEmailLive do
  use ApiWeb, :live_view
  use ApiWeb, :user_auth

  alias Api.Accounts.User


  @impl true
  def mount(%{"email" => email} = params, session, socket) do

  user = Api.Accounts.get_user_by_email(email)

  user = case user  do
    nil -> %User{email: "", confirmed_at: "", role: ""}
    _-> user
  end

    socket = assign_defaults(session, socket)
 socket = assign(socket, :user_data, user)

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
