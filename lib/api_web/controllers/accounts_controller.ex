defmodule ApiWeb.AccountsController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias ApiWeb.UserAuth


  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def list(conn, _params) do
    render(conn, "list.html")
  end

end
