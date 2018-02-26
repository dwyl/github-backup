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
        issues = @github_api.get_issues(token, payload)
        comments = @github_api.get_comments(token, payload)

      :issue_edited ->
        token = @github_api.get_installation_token(payload["installation"]["id"])
        issues = @github_api.get_issues(token, payload)
                 |> Enum.filter(fn i -> !Map.has_key?(i, "pull_request")end )
        # IO.inspect "********************************"
        # IO.inspect issues
        # IO.inspect "%%%%%%%%%%%"
        # IO.inspect length(issues)
        # IO.inspect "********************************"
    end

    conn
    |> put_status(200)
    |> json(%{ok: "event received"})
  end
end
