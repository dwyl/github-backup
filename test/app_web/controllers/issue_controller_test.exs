defmodule AppWeb.IssueControllerTest do
  use AppWeb.ConnCase
  alias App.{Issue, Version, Repo}

  describe "loads issue page" do
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

    test "GET /issues/1", %{conn: conn} do
      conn = get conn, "/issues/1"
      assert html_response(conn, 200) =~ "Test issue title"
    end
  end
end
