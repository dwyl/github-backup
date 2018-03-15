defmodule AppWeb.IssueControllerTest do
  use AppWeb.ConnCase
  alias App.{Issue, Repo}

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
      issue_params2 = %{
              issue_id: 2,
              title: "Test issue title2",
              comments: [
                %{
                  comment_id: "1_2",
                  versions: [%{author: "SimonLab"}]
                }
              ],
              issue_status: [
                %{
                  event: "closed"
                }
              ]
            }

      changeset = Issue.changeset(%Issue{}, issue_params)
      issue = Repo.insert!(changeset)

      changeset2 = Issue.changeset(%Issue{}, issue_params2)
      issue2 = Repo.insert!(changeset2)


      {:ok, conn: build_conn() |> assign(:issue, issue) |> assign(:issue2, issue2)}
    end
    test "GET /issues/2", %{conn: conn} do
      conn = get conn, "/issues/2"
      assert html_response(conn, 200) =~ "Test issue title2"
    end

    test "GET /issues/1", %{conn: conn} do
      conn = get conn, "/issues/1"
      assert html_response(conn, 200) =~ "Test issue title"
    end
  end
end
