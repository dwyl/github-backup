defmodule AppWeb.Plugs.GHOAuth do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    user = conn.assigns.current_user
    case user do
      false ->
        conn
        |> Phoenix.Controller.redirect(to: AppWeb.Router.Helpers.auth_path(conn, :request, "github"))
        |> halt()
      _ ->
        conn
    end
  end
end
