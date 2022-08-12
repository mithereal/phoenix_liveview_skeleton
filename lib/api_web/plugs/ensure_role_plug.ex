defmodule ApiWeb.Plug.EnsureRole do
  @moduledoc """
  This plug ensures that a user has a particular role before accessing a given route.

  ## Example
  Let's suppose we have three roles: :admin, :manager and :user.

  If you want a user to have at least manager role, so admins and managers are authorised to access a given route
  plug ApiWeb.Plug.EnsureRole, [:admin, :manager]

  If you want to give access only to an admin:
  plug ApiWeb.Plug.EnsureRole, :admin
  """
  import Plug.Conn

  alias Api.Accounts
  alias Api.Accounts.User
  alias Phoenix.Controller
  alias Plug.Conn

  use Terminator

  @doc false
  @spec init(any()) :: any()
  def init(config), do: config

  @doc false
  @spec call(Conn.t(), atom() | [atom()]) :: Conn.t()
  def call(conn, roles) do
    user_token = get_session(conn, :user_token)

    (user_token &&
       Accounts.get_user_by_session_token(user_token))
    |> user_has_role?(roles)
    |> maybe_halt(conn)
  end

  defp user_has_role?(user, roles) do
      Enum.map(roles, fn role -> has_role?(user.performer, role) end)
      |> Enum.member?(:ok) |> IO.inspect()
  end

  defp user_has_role?(_user, _role), do: false

  defp maybe_halt(true, conn), do: conn

  defp maybe_halt(_any, conn) do
    conn
    |> Controller.put_flash(:error, "Unauthorised")
    |> Controller.redirect(to: signed_in_path(conn))
    |> halt()
  end

  defp signed_in_path(_conn), do: "/"
end
