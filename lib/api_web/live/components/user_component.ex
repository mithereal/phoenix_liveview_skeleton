defmodule ApiWeb.UserComponent do
  use ApiWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
     <div class="h-24 flex items-center justify-between border border-gray-400 border-l-8 border-l-indigo-500 shadow-xl rounded-lg px-4">

    <div>
    <p class="uppercase text-sm text-indigo-500 font-bold"><%= @email %></p>

      <button class="bg-primary hover:bg-primary-dark hover:shadow-xl text-gray-100 text-sm px-3 py-1.5 rounded-lg mx-4 my-2" title="Show">
    <a href ="/admin/profile/<%= @email %>" class="bg-blue-300 hover:bg-blue-400 text-gray-800 font-bold py-2 px-4 rounded-r"><span>Show</span></a>
</button>
   <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-indigo-200" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>

    </div>

    </div>

    """
  end
end
