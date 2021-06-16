defmodule ApiWeb.ErrorComponent do
  use ApiWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="w-full px-4 md:px-0 md:mt-8 mb-16 text-gray-800 leading-normal">

     <h1>Flames</h1>

    <ul>
     <%=  for x <- @errors do %>
    <li></li>
     <% end %>
    </ul>
    </div>
    """
  end
end
