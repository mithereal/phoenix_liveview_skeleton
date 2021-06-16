defmodule ApiWeb.Plug.Common do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    version = Api.Application.version()
    codename = Api.Application.codename()

    conn = Plug.Conn.assign(conn, :version, version)
    Plug.Conn.assign(conn, :codename, codename)
  end
end
