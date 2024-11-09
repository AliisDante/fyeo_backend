defmodule FyeoBackendWeb.APIPlugs do
  import Plug.Conn

  def add_acao_header(%Plug.Conn{} = conn, _opts) do
    put_resp_header(conn, "Access-Control-Allow-Origin", "*")
  end
end
