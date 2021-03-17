defmodule ApiWeb.UserComponent do
  use ApiWeb, :live_component

  @impl true
  def render(assigns) do
  ~L"""
  <div class = "label_cell"><%= @user.email %></div>
    <div class = "label_cell"><%= @user.role %></div>

      <div class="inline-flex">
  <button class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded-l">
   <span> Edit</span>
  </button>
  <button class="bg-blue-300 hover:bg-blue-400 text-gray-800 font-bold py-2 px-4 rounded-r">
    <span>Show</span>
  </button>
</div>
  """
  end


end
