defmodule ApiWeb.AdminFlamesLive do
  use ApiWeb, :live_view
  use ApiWeb, :user_auth

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    if connected?(socket), do: Api.Admin.subscribe("Admin", "Errors")

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
       <%=  live_component(@socket,  ApiWeb.ErrorComponent, assigns) %>

    """
  end

  def handle_info(
        {_requesting_module, [:data, :updated], %{errors: errors}},
        socket
      ) do
    total_errors = Enum.count(errors)
    socket = assign(socket, :total_errors, total_errors)
    socket = assign(socket, :errors, errors)

    {:noreply, socket}
  end
end
