defmodule AppWeb.EventType do
  alias AppWeb.EventTypeHandlers

  @moduledoc """
  Determines the type of event received by the Github Webhooks requests
  """

  def get_event_type(x_github_event, action, conn, payload) do
    case x_github_event do
      "installation" -> type("installation", action, conn, payload)
      "installation_repositories" -> type("installation_repositories", action, conn, payload)
      "issues" -> type("issues", action, conn, payload)
      "issue_comment" -> type("issue_comment", action, conn, payload)
      _ -> nil
    end
  end

  defp type("installation", action, conn, payload) do
    case action do
      "created" -> EventTypeHandlers.new_installation(conn, payload)
    end
  end

  defp type("installation_repositories", action) do
    case action do
      "added" -> :new_installation_repositories
    end
  end

  defp type("issues", action, conn, payload) do
    case action do
      "opened" -> EventTypeHandlers.issue_created(conn, payload)
      "edited" -> EventTypeHandlers.issue_edited(conn, payload)
      "closed" -> :issue_closed
      "reopened" -> :issue_reopened
    end
  end

  defp type("issue_comment", action, conn, payload) do
    case action do
      "created" -> EventTypeHandlers.comment_created(conn, payload)
      "edited" -> EventTypeHandlers.comment_edited(conn, payload)
      "deleted" -> EventTypeHandlers.comment_deleted(conn, payload)
    end
  end
end
