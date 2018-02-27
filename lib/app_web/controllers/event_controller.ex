defmodule AppWeb.EventController do
  use AppWeb, :controller
  alias AppWeb.EventType

  @github_api Application.get_env(:app, :github_api)

  def new(conn, payload) do
    headers = Enum.into(conn.req_headers, %{})
    x_github_event = Map.get(headers, "x-github-event")

    case EventType.get_event_type(x_github_event, payload["action"]) do
      :new_installation ->
        token = @github_api.get_installation_token(payload["installation"]["id"])
        issues = @github_api.get_issues(token, payload, 1, [])
        comments = @github_api.get_comments(token, payload)

      _ -> nil
    end

    conn
    |> put_status(200)
    |> json(%{ok: "event received"})
  end
end
