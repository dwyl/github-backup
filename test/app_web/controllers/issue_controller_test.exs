defmodule AppWeb.IssueControllerTest do
  use AppWeb.ConnCase
  alias App.Issue

  test "GET /issue/301816228", %{conn: conn} do
    conn = get conn, "issue/301816228"

    Repo.insert %Issue{issue_id: 301816228, title: "3rd Test Issue -"}

    assert html_response(conn, 200) =~ "Test issue description"
  end
end
