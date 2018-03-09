defmodule AppWeb.IssueControllerTest do
  use AppWeb.ConnCase

  test "GET /issues/1", %{conn: conn} do
    conn = get conn, "/issues/1"
    assert html_response(conn, 200) =~ "Issue Page"
  end
end
