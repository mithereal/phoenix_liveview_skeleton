defmodule ApiWeb.Plug.Attack do
  import Plug.Conn
  use PlugAttack

  # For more rules examples see PlugAttack.rule/2 macro documentation.
  rule "allow local", conn do
    allow(conn.remote_ip == {127, 0, 0, 1})
  end

  rule "throttle per ip", conn do
    # throttle to 25 requests per second
    throttle(conn.remote_ip,
      period: 1_000,
      limit: 25,
      storage: {PlugAttack.Storage.Ets, ApiWeb.Plug.Attack.Storage}
    )
  end

  rule "throttle login requests", conn do
    if conn.method == "POST" and conn.path_info == ["login"] do
      throttle(conn.params["email"],
        period: 60_000,
        limit: 10,
        storage: {PlugAttack.Storage.Ets, ApiWeb.Plug.Attack.Storage}
      )
    end
  end

  # It's possible to customize what happens when conn is let through
  def allow_action(conn, _data, _opts), do: conn

  # Or when it's blocked
  def block_action(conn, _data, _opts) do
    conn
    |> send_resp(:forbidden, "Forbidden\n")
    |> halt
  end
end
