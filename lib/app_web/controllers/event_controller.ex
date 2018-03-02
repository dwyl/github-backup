defmodule AppWeb.EventController do
  use AppWeb, :controller
  alias AppWeb.EventType
  alias App.Issue

  @github_api Application.get_env(:app, :github_api)

  def new(conn, payload) do
    headers = Enum.into(conn.req_headers, %{})
    x_github_event = Map.get(headers, "x-github-event")

    case EventType.get_event_type(x_github_event, payload["action"]) do
      :new_installation ->
        token = @github_api.get_installation_token(payload["installation"]["id"])
        issues = @github_api.get_issues(token, payload, 1, [])
        comments = @github_api.get_comments(token, payload)

      :issue_created ->
        IO.inspect "111111111111111111111111"
        IO.inspect payload
        IO.inspect "111111111111111111111111"
        issue_params = %{
          issue_id: payload["issue"]["id"],
          title: payload["issue"]["title"]
        }

      :issue_edited ->
        IO.inspect "AAAAAAAAAAAAAAAAAAAAAAAAA"
        issue_params = %{
          issue_id: payload["issue"]["id"],
          title: payload["issue"]["title"]
        }
        IO.inspect issue_params
        changeset = Issue.changeset(%Issue{}, issue_params)
        IO.inspect changeset

        # What
        # validate the GithubIssuePayload
        # create and extract from GithubIssuePayload schema
        # Issue: title, html_url, issue_id
        # Comment: ref to issue_id, html_url (same as the issue url), comment_id
        # User: login, html_url (we can add all the fields later on)
        # Versions: ref to Comment, ref to User
        # save all the data
        # save file in s3 {version_id: "text", ...}

        #How
        # Break schema in smaller one, p18:
          # use embedded_schema to define a schema that won't be save in DB
          # apply_changes fct to get the schema after validation
          # Create fcts to extract the field necessary for the Issue, Comment, User tables; use schemaless queries
          #GithubIssuePayload -> Issue  Comment and User

      _ -> nil
    end

    conn
    |> put_status(200)
    |> json(%{ok: "event received"})
  end
end
