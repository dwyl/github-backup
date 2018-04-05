defmodule AppWeb.EventTestController do
  use AppWeb.ConnCase
  alias Poison.Parser, as: PP
  alias Plug.Conn

  @fixtures [
    %{payload: "installation", event: "installation", json_reply: "new installation", status: 200},
    # %{payload: "installation_repositories", event: "installation_repositories", json_reply: "new installation", status: 200},
    %{payload: "issue_opened", event: "issues", json_reply: "issue created", status: 200},
    %{payload: "issue_closed", event: "issues", json_reply: "issue closed", status: 200},
    %{payload: "issue_reopened", event: "issues", json_reply: "issue reopened", status: 200},
    %{payload: "issue_title_edited", event: "issues", json_reply: "issue edited", status: 200},
    %{payload: "issue_edited", event: "issues", json_reply: "issue edited", status: 200},
    %{payload: "pr_opened", event: "pull_request", json_reply: "issue created", status: 200},
    %{payload: "pr_edited", event: "pull_request", json_reply: "issue edited", status: 200},
    %{payload: "pr_closed", event: "pull_request", json_reply: "issue closed", status: 200},
    %{payload: "pr_reopened", event: "pull_request", json_reply: "issue reopened", status: 200},
    %{payload: "comment_created", event: "issue_comment", json_reply: "comment created", status: 200},
    %{payload: "comment_edited", event: "issue_comment", json_reply: "comment edited", status: 200},
    %{payload: "comment_deleted", event: "issue_comment", json_reply: "comment deleted", status: 200},
    %{payload: "integration_installation", event: "integration_installation", json_reply: "event unknow", status: 404}
  ]
  |> Enum.map(&(%{&1 | payload: "./test/fixtures/#{&1.payload}.json"}))

  test "POST /event/new", %{conn: conn} do
    for fixture <- @fixtures do
      payload = fixture.payload |> File.read! |> PP.parse!
      conn =
        conn
        |> Conn.put_req_header("x-github-event", "#{fixture.event}")
        |> post("/event/new", payload)
      assert json_response(conn, fixture.status)
    end
  end
end
