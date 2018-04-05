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
      "pull_request"-> type("pull_request", action, conn, payload)
      _ -> type("unknow", conn)
    end
  end

  defp type("unknow", conn) do
    EventTypeHandlers.unknow_event(conn)
  end

  defp type("installation", action, conn, payload) do
    case action do
      "created" -> EventTypeHandlers.new_installation(conn, payload)
    end
  end

  defp type("installation_repositories", action, conn, payload) do
    case action do
      "added" -> EventTypeHandlers.new_installation(conn, payload)
    end
  end

  defp type("issues", action, conn, payload) do
    case action do
      "opened" -> EventTypeHandlers.issue_created(conn, payload)
      "edited" -> EventTypeHandlers.issue_edited(conn, payload)
      "closed" -> EventTypeHandlers.issue_closed(conn, payload)
      "reopened" -> EventTypeHandlers.issue_reopened(conn, payload)
    end
  end

  defp type("issue_comment", action, conn, payload) do
    case action do
      "created" -> EventTypeHandlers.comment_created(conn, payload)
      "edited" -> EventTypeHandlers.comment_edited(conn, payload)
      "deleted" -> EventTypeHandlers.comment_deleted(conn, payload)
    end
  end

  defp type("pull_request", action, conn, payload) do
    case action do
      "opened" -> EventTypeHandlers.issue_created(conn, payload)
      "edited" -> EventTypeHandlers.issue_edited(conn, payload)
      "closed" -> EventTypeHandlers.issue_closed(conn, payload)
      "reopened" -> EventTypeHandlers.issue_reopened(conn, payload)
    end
  end
end
