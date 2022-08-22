defmodule ApiWeb.PageController do
  use ApiWeb, :controller

  def privacy(conn, _params) do
    render(conn, "privacy.html")
  end

  def terms(conn, _params) do
    render(conn, "terms.html")
  end
end
