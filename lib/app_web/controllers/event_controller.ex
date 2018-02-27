defmodule AppWeb.EventController do
  use AppWeb, :controller
  alias AppWeb.EventType
  alias AppWeb.AWS.S3

  @github_api Application.get_env(:app, :github_api)

  def new(conn, payload) do
    headers = Enum.into(conn.req_headers, %{})
    x_github_event = Map.get(headers, "x-github-event")

# Was originally tryig to get the payload data in order to save it in here. Since
# Doing JC's tutorial I now also have an upload controller and so perhaps this
# should happen there?
    # S3.saveToS3(payload)

    case EventType.get_event_type(x_github_event, payload["action"]) do
      :new_installation ->
        token = @github_api.get_installation_token(payload["installation"]["id"])
        issues = @github_api.get_issues(token, payload)
        comments = @github_api.get_comments(token, payload)

      _ -> nil
    end

    conn
    |> put_status(200)
    |> json(%{ok: "event received"})
  end
end
