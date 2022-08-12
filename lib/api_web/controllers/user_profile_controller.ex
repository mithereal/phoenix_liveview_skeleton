defmodule ApiWeb.UserProfileController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias ApiWeb.UserAuth

  def show(conn) do
    user =
      conn.assigns.current_user.id
      |> Api.Accounts.User.get_user()

    render(conn, "show.html", data: user.profile)
  end

  def show(conn, %{"json" => json}) do
    user =
      conn.assigns.current_user.id
      |> Api.Accounts.User.get_user()

    render(conn, "show.json", data: user.profile)
  end

  def edit(conn) do
    user =
      conn.assigns.current_user.id
      |> Api.Accounts.User.get_user()

    render(conn, "edit.html", data: user.profile)
  end

  def edit(conn, %{"json" => json}) do
    ## show the schema
    user =
      conn.assigns.current_user.id
      |> Api.Accounts.User.get_user()

    render(conn, "edit.json", data: user.profile)
  end

  def update(conn, %{"data" => data}) do
    user =
      conn.assigns.current_user.id
      |> Api.Accounts.User.get_user()

    data = Jason.decode!(data)

    Api.User.Server.update(user.id, data)
    render(conn, "edit.html", data: user.profile)
  end
end
