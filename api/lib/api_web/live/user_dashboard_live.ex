defmodule ApiWeb.UserDashboardLive do
  use ApiWeb, :live_view
  use ApiWeb, :user_auth

  @impl true
  def handle_info(%{event: "logout_user", payload: %{user: %User{id: id}}}, socket) do
    with %User{id: ^id} <- socket.assigns.current_user do
      {:noreply,
       socket
       |> redirect(to: Routes.user_session_path(socket, :force_logout))}
    else
      _any -> {:noreply, socket}
    end
  end

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <h1>Welcome to the user dashboard!</h1>
    </section>
    """
  end
end
