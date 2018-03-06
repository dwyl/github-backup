defmodule AppWeb.EventTestController do
  use AppWeb.ConnCase
  alias Poison.Parser, as: PP
  alias Plug.Conn

  @fixtures [
    %{payload: "installation", event: "installation"},
    %{payload: "issue_opened", event: "issues"},
    %{payload: "issue_title_edited", event: "issues"},
    %{payload: "issue_edited", event: "issues"},
    %{payload: "comment_created", event: "issue_comment"},
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
