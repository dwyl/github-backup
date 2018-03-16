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
              title: "Test issue title 2",
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

        issue_params3 = %{
                issue_id: 3,
                title: "Test issue title 3",
                comments: [
                  %{
                    comment_id: "1_3",
                    versions: [%{author: "SimonLab"}]
                  }
                ],
                issue_status: [
                  %{
                    event: "reopened"
                  }
                ]
              }

      changeset = Issue.changeset(%Issue{}, issue_params)
      changeset2 = Issue.changeset(%Issue{}, issue_params2)
      changeset3 = Issue.changeset(%Issue{}, issue_params3)
      issues = Repo.insert!(changeset)
      issue2 = Repo.insert!(changeset2)
      issue3 = Repo.insert!(changeset3)

      {:ok, conn: build_conn()
      |> assign(:issue, issues)
      |> assign(:issue2, issue2)
      |> assign(:issue3, issue3)}
    end

    test "GET /issues/1", %{conn: conn} do
      conn = get conn, "/issues/1"
      assert html_response(conn, 200) =~ "Test issue title"
    end

    test "GET /issues/2", %{conn: conn} do
      conn = get conn, "/issues/2"
      assert html_response(conn, 200) =~ "Test issue title 2"
    end

    test "GET /issues/3", %{conn: conn} do
      conn = get conn, "/issues/3"
      assert html_response(conn, 200) =~ "Test issue title 3"
    end
  end
end
