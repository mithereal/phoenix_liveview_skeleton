defmodule ApiWeb.CSPHeader do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    put_resp_header(conn, "content-security-policy", csp(conn))
  end

  defp csp(conn) do
    "default-src 'self'; \
          connect-src 'self' #{ws_url(conn)} #{ws_url(conn, "wss")}; \
          script-src 'self' 'unsafe-inline' 'unsafe-eval'; \
          img-src img-src * 'self' data: https:; \
          style-src 'self' 'unsafe-inline' 'unsafe-eval'"
  end

  defp ws_url(conn, protocol \\ "ws") do
    endpoint = Phoenix.Controller.endpoint_module(conn)
    %{endpoint.struct_url | scheme: protocol} |> URI.to_string()
  end
end
