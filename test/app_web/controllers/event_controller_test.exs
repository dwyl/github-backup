defmodule AppWeb.EventTestController do
  use AppWeb.ConnCase
  alias Poison.Parser, as: PP
  alias Plug.Conn

  @fixtures [
    %{payload: "installation", event: "installation", json_reply: "new installation"},
    %{payload: "issue_opened", event: "issues", json_reply: "issue created"},
    %{payload: "issue_title_edited", event: "issues", json_reply: "issue edited"},
    %{payload: "issue_edited", event: "issues", json_reply: "issue edited"},
    %{payload: "comment_created", event: "issue_comment", json_reply: "comment created"},
    %{payload: "comment_edited", event: "issue_comment", json_reply: "comment created"},
    %{payload: "comment_deleted", event: "issue_comment", json_reply: "comment deleted"}
  ]
  |> Enum.map(&(%{&1 | payload: "./test/fixtures/#{&1.payload}.json"}))

  test "POST /event/new", %{conn: conn} do
    for fixture <- @fixtures do
      payload = fixture.payload |> File.read! |> PP.parse!
      conn = conn
      |> Conn.put_req_header("x-github-event", "#{fixture.event}")
      |> post("/event/new", payload)
      assert json_response(conn, 200)
    end
  end
end
