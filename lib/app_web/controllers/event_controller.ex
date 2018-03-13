defmodule AppWeb.EventController do
  use AppWeb, :controller
  alias AppWeb.EventType

  def new(conn, payload) do
    headers = Enum.into(conn.req_headers, %{})
    x_github_event = Map.get(headers, "x-github-event")
    github_webhook_action = payload["action"]

    EventType.get_event_type(
      x_github_event, github_webhook_action, conn, payload
    )
  end
end
