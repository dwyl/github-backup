defmodule AppWeb.AuthController do
  use AppWeb, :controller
  plug Ueberauth

  def callback(conn, _params) do
    IO.inspect(conn.assigns, label: "----------------> in callback")
    redirect(conn, to: auth_path(conn, :index))
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
