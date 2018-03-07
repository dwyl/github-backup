defmodule AppWeb.CommentControllerTest do
  use AppWeb.ConnCase
  alias App.{Issue, Repo}

  describe "loads comment page" do
    setup do
      issue_params = %{
        issue_id: 1,
        title: "Test issue title",
        comments: [
          %{
            comment_id: "1_1",
            versions: [%{author: "SimonLab"}]
          }
        ]
      }

      changeset = Issue.changeset(%Issue{}, issue_params)
      issue = Repo.insert!(changeset)
      {:ok, conn: build_conn() |> assign(:issue, issue)}
    end

    test "GET /comments/1_1", %{conn: conn} do
      conn = get conn, "comments/1_1"

      assert html_response(conn, 200) =~ "Test issue title"
    end
  end
end
