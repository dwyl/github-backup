defmodule AppWeb.EventController do
  use AppWeb, :controller

  def new(conn, _payload) do
    conn
    |> put_status(200)
    |> json(%{ok: "event received"})
  end
end
