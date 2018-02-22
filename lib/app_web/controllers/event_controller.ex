defmodule AppWeb.EventController do
  use AppWeb, :controller

  @github_api Application.get_env(:app, :github_api)

  def new(conn, payload) do
    case event_type(conn, payload) do
      :new_installation ->
        token = @github_api.get_installation_token(payload["installation"]["id"])
        issues = @github_api.get_issues(token, payload)
        comments = @github_api.get_comments(token, payload)

      :issue_edited -> nil

      _ -> nil
    end

    conn
    |> put_status(200)
    |> json(%{ok: "event received"})
  end

  defp event_type(conn, payload) do
    action = payload["action"]
    headers = Enum.into(conn.req_headers, %{})
    x_github_event = Map.get(headers, "x-github-event")

    case x_github_event do
      "installation" -> type("installation", action)
      "installation_repositories" -> type("installation_repositories", action)
      "issues" -> type("issues", action)
      "issue_comment" -> type("issue_comment", action)
      _ -> nil
    end
  end

  defp type("installation", action) do
    case action do
      "created" -> :new_installation
    end
  end

  defp type("installation_repositories", action) do
    case action do
      "added" -> :new_installation_repositories
    end
  end

  defp type("issues", action) do
    case action do
      "edited" -> :issue_edited
      "closed" -> :issue_closed
      "reopened" -> :issue_reopened
    end
  end

  defp type("issue_comment", action) do
    case action do
      "edited" -> :comment_created
      "closed" -> :comment_edited
      "deleted" -> :comment_deleted
    end
  end
end
