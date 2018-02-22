defmodule AppWeb.EventType do
  @moduledoc """
  Determines the type of event received by the Github Webhooks requests
  """

  def get_event_type(x_github_event, action) do
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
      "created" -> :issue_created
      "edited" -> :issue_edited
      "closed" -> :issue_closed
      "reopened" -> :issue_reopened
    end
  end

  defp type("issue_comment", action) do
    case action do
      "created" -> :comment_created
      "edited" -> :comment_edited
      "deleted" -> :comment_deleted
    end
  end
end
