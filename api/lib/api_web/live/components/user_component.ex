defmodule ApiWeb.UserComponent do
  use ApiWeb, :live_component

  @impl true
  def render(assigns) do
  ~L"""
     <div class="user">
    <ul>
    <li>
    <%= @user.email %>
    </li>
    <li>
    <%= @user.role %>
    </li>
    </ul>
    </div>
  """
  end


end
