defmodule ApiWeb.Plug.Common do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    version = Api.Application.version()

    Plug.Conn.assign(conn, :version, version)
  end
end
