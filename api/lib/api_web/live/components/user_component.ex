defmodule ApiWeb.UserComponent do
  use ApiWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
     <div class="w-full px-4 md:px-0 md:mt-8 mb-16 text-gray-800 leading-normal">

    <div class = "label_cell"><%= @email %>

       <div class="inline-flex">
 <button class="bg-blue-300 hover:bg-blue-400 text-gray-800 font-bold py-2 px-4 rounded-r"><span>Show</span></button>
 </div>

    </div>

    </div>

    """
  end
end
