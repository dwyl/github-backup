defmodule AppWeb.EventType do
  @moduledoc """
  Determines the type of event received by the Github Webhooks requests
  """

  def event_type(conn, payload) do
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
