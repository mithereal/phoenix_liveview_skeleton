defmodule ApiWeb.ProfileComponent do
  use ApiWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
 <div class="w-full px-4 md:px-0 md:mt-8 mb-16 text-gray-800 leading-normal">

     <h1>Profile</h1>

    <ul>
    <li><%= @user_data.email %></li>
    <li><%= @user_data.role %></li>
    <li><%= @user_data.confirmed_at %></li>
    </ul>
</div>
    """
  end
end
