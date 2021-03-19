defmodule ApiWeb.UserComponent do
  use ApiWeb, :live_component

  @impl true
  def render(assigns) do
  ~L"""
  <div class = "label_cell"><%= @email %></div>

      <div class="inline-flex">
  <button class="bg-blue-300 hover:bg-blue-400 text-gray-800 font-bold py-2 px-4 rounded-r">
    <span>Show</span>
  </button>
</div>
  """
  end


end
