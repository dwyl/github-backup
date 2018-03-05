defmodule AppWeb.EventController do
  use AppWeb, :controller
  alias AppWeb.{EventType, AWS.S3}
  alias App.{Issue, Repo}

  @github_api Application.get_env(:app, :github_api)
  @s3_api Application.get_env(:app, :s3_api)

  def new(conn, payload) do
    headers = Enum.into(conn.req_headers, %{})
    x_github_event = Map.get(headers, "x-github-event")

    case EventType.get_event_type(x_github_event, payload["action"]) do
      :new_installation ->
        token = @github_api.get_installation_token(payload["installation"]["id"])
        issues = @github_api.get_issues(token, payload, 1, [])
        comments = @github_api.get_comments(token, payload)

        conn
        |> put_status(200)
        |> json(%{ok: "new installation"})

      :issue_created ->
        issue_params = %{
          issue_id: payload["issue"]["id"],
          title: payload["issue"]["title"],
          comments: [
            %{
              comment_id: "#{payload["issue"]["id"]}_1",
              versions: [%{author: payload["issue"]["user"]["login"]}]
            }
          ]
        }

        changeset = Issue.changeset(%Issue{}, issue_params)
        issue = Repo.insert!(changeset)

        comment = payload["issue"]["body"]
        version_id = issue.comments
                     |> List.first()
                     |> Map.get(:versions)
                     |> List.first()
                     |> Map.get(:id)

        @s3_api.save_comment(issue.issue_id, Poison.encode!(%{version_id => comment}))

        conn
        |> put_status(200)
        |> json(%{ok: "issue created"})

      :issue_edited -> nil

      _ -> nil
    end
  end
end
