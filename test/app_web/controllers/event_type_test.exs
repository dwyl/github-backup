defmodule AppWeb.EventTypeTest do
  use AppWeb.ConnCase
  alias AppWeb.EventType

  test "get event type" do
    assert EventType.get_event_type("installation", "created") == :new_installation
    assert EventType.get_event_type("installation_repositories", "added") == :new_installation_repositories

    assert EventType.get_event_type("issue_comment", "created") == :comment_created
    assert EventType.get_event_type("issue_comment", "edited") == :comment_edited
    assert EventType.get_event_type("issue_comment", "deleted") == :comment_deleted

    assert EventType.get_event_type("issues", "created") == :issue_created
    assert EventType.get_event_type("issues", "edited") == :issue_edited
    assert EventType.get_event_type("issues", "closed") == :issue_closed
    assert EventType.get_event_type("issues", "reopened") == :issue_reopened
  end

end
