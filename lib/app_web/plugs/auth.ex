defmodule AppWeb.Plugs.Auth do
  import Plug.Conn

  def init(_) do
  end

  def call(conn, _) do
    user_id = get_session(conn, :user_id)
    case user_id do
      nil ->
        assign(conn, :current_user, false)
      _ ->
        assign(conn, :current_user, user_id)
    end
  end
end
