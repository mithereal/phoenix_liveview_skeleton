defmodule ApiWeb.PageController do
  use ApiWeb, :controller

  def privacy(conn, _) do
    render(conn, "privacy.html")
  end

  def terms(conn, _) do
    render(conn, "terms.html")
  end
end
