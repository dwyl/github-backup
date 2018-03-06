defmodule AppWeb.CommentControllerTest do
  use AppWeb.ConnCase
  alias App.{Comment, Repo}

  test "GET /comments/302728924_1", %{conn: conn} do
    Repo.insert %Comment{comment_id: "302728924_1", issue_id: 4}

    conn = get conn, "comments/302728924_1"

    assert html_response(conn, 200) =~ "This is the copy of the new issue."
  end
end
