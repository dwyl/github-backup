defmodule AppWeb.AuthController do
  use AppWeb, :controller
  plug Ueberauth

  def callback(conn, params) do
    gh_user_id = conn.assigns.ueberauth_auth.extra.raw_info.user["id"]

    conn
    |> put_session(:user_id, gh_user_id)
    |> redirect(to: issue_path(conn, :show, 236297481)) #update hardcoded issue
    # |> configure_session(renew: true)
  end
end
