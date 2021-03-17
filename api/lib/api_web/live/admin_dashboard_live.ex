defmodule ApiWeb.AdminDashboardLive do
  use Phoenix.LiveView, layout: {ApiWeb.LayoutView, "admin.html"}
  use ApiWeb, :user_auth

  @impl true
  def mount(_params, session, socket) do
    #    socket = assign_defaults(session, socket)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <section class=" bg-gray-800 pt-2 md:pt-1 pb-1 px-1 mt-0 h-auto fixed w-full">
      <h1>Welcome to the admin dashboard!</h1>
    </section>
    """
  end
end
