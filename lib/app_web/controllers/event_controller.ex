defmodule AppWeb.EventController do
  use AppWeb, :controller

  @github_api Application.get_env(:app, :github_api)

  def new(conn, payload) do
    token = @github_api.get_installation_token(payload["installation"]["id"])
    conn
    |> put_status(200)
    |> json(%{ok: "event received"})
  end
end
