defmodule ApiWeb.ProfileComponent do
  use ApiWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
 <div class="w-full px-4 md:px-0 md:mt-8 mb-16 text-gray-800 leading-normal">

     <h1>Profile</h1>

    <ul>
    <li><%= @current_user.email %></li>
    <li><%= @current_user.role %></li>
    <li><%= @current_user.confirmed_at %></li>
    </ul>
</div>
    """
  end
end
